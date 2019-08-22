//
//  CheckOutController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/27/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions
import CoreLocation

class CheckOutController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = LocationService.locationManager
    var paymentContext: STPPaymentContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfCartEmpty()
        setUpTableView()
        setUpPaymentInfo()
        setUpStripeConfig()
    }
    
    func checkIfCartEmpty() {
        print("empty")
        if StripeCart.isEmpty {
            let message = "You'll need to add items to your cart first!"
            self.displayError(title: "Empty Cart", message: message, completion: {_ in
                self.dismiss(animated: true, completion: nil)
            })
            return
        }
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpPaymentInfo() {
        subtotalLabel.text = StripeCart.penniesToFormattedCurrency(numberInPennies: StripeCart.subtotal)
        processingFeeLabel.text = StripeCart.penniesToFormattedCurrency(numberInPennies:  StripeCart.processingFees)
        deliveryFeeLabel.text = StripeCart.penniesToFormattedCurrency(numberInPennies:  StripeCart.deliveryFee)
        totalLabel.text = StripeCart.penniesToFormattedCurrency(numberInPennies:  StripeCart.total)
    }
    
    func setUpStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        
        // this class will retrieve and update the customer object using the ephemeral key that it gets from the cloud function that is called from the StripeApi
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        
        
    }
    
    func presentLocationDetails() {
        let locationController = AddLocationController()
        
        locationController.modalTransitionStyle = .coverVertical
        locationController.modalPresentationStyle = .overCurrentContext
        present(locationController, animated: true, completion: nil)
    }
    
    func presentSuccessAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: {(action) in
            self.performSegue(withIdentifier: Segues.toMapController, sender: nil)
        })
        
        alertController.addAction(okay)
        self.present(alertController, animated: true)
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.presentPaymentOptionsViewController()
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        checkLocationServices()
//        checkIfCartEmpty()
//        activityIndicator.startAnimating()
//        paymentContext.requestPayment()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CheckOutController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        checkIfCartEmpty()
        
        activityIndicator.stopAnimating()
        // updating selected payment method text
        if let paymentMethod = paymentContext.selectedPaymentOption{
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
            print("got payment method bc it changed")
        }
        else {
            paymentMethodButton.setTitle("Select Method", for: .normal)
            print("could not get payment method afteer change")
        }
    }
    
    // called if there was an error getting payment info from customer
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        let alertContoller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let retry = UIAlertAction(title: "Retry", style: .default, handler: {(action) in
            self.paymentContext.retryLoading()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertContoller.addAction(cancel)
        alertContoller.addAction(retry)
        present(alertContoller, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let data: [String: Any] = [
            DataParams.total: StripeCart.total,
            DataParams.customer_id: UserService.user.stripeId,
            DataParams.idempotency: idempotency,
        ]
        
        // call cloud function to make request to make payment
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                // present alert saying Unable to make charge
                completion(error)
                return
            }
            
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.setUpPaymentInfo()
            completion(nil)
            
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        activityIndicator.stopAnimating()

        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? "unable to get error message in cart"
            print("was error")
            break
        case .success:
            title = "Success!"
            message = "Thank you for your purchase"
            print("was successful")
            self.presentSuccessAlert(title: title, message: message)
            break
        case .userCancellation:
            print("user cancel")
            return
        }
            
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okay)
        self.present(alertController, animated: true)
    }
    
    func notificationsAreEnabled() -> Bool {
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        // NOTIFICATIONS DISABLED
        if notificationType == [] {
            self.displayError(title: "Please Enable Notifications", message: "Please enable push notifications so we can let you know when your order is here.", completion: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            })
            return false
            // NOTIFICATIONS ENABLED
        } else {
            return true
        }
    }
}

extension CheckOutController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = StripeCart.cartItems[row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ShoppingCartCell) as? ShoppingCartCell {
            cell.numItemsLabel.text = String(item.amountOrdered)
            cell.titleLabel.text = item.name
            cell.itemDescriptionLabel.text = item.description
            cell.costLabel.text = "$" + String(format: "%.2f", item.price)
            return cell
        }
        print("ERROR: trouble loading cell in cart")
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = StripeCart.cartItems[indexPath.row]
            StripeCart.removeItemFromCart(item: product)
            
            paymentContext.paymentAmount = StripeCart.total
            
            self.setUpPaymentInfo()
            self.tableView.reloadData()
        }
    }
}

extension CheckOutController: CLLocationManagerDelegate {
    func navigateToLocationSettings() {
        let message = "Please enable location for the app so we can let your Roamer know where to deliver your meal."
        self.displayError(title: "Please Enable Location Services", message: message, completion: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
    }
    
    func getMyLocation() {
        locationManager.startUpdatingLocation()
        guard let longitude = locationManager.location?.coordinate.longitude,
              let latitude = locationManager.location?.coordinate.latitude
              else {
                self.displayError(title: "Network Error", message: "Unable to determine Location")
                locationManager.stopUpdatingLocation()
                return
              }
        locationManager.stopUpdatingLocation()
        LocationService.updateLocation()
        print(longitude,latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            getMyLocation()
            presentLocationDetails()
            break
        case .denied:
            // show alert telling them how to turn on notifiations
            navigateToLocationSettings()
            break
        case .notDetermined:
            // when we request the permission for first time
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // parental control restriction
            navigateToLocationSettings()
            break
        case .authorizedAlways:
            // do map stuff
            getMyLocation()
            presentLocationDetails()
            break
        @unknown default:
            break
        }
    }
    
    func checkLocationServices() {
        // if location is enabled device wide
        if CLLocationManager.locationServicesEnabled() {
            if ( !notificationsAreEnabled() ) { return }
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert telling user they have to turn this on.
            navigateToLocationSettings()
        }
    }
}

