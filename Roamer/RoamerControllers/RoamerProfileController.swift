//
//  RoamerProfileController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/25/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class RoamerProfileController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePictureView: RoundedProfilePicture!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        
        profilePictureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraClicked)))
        tryToGetProfilePic()
    }
    
    
    
    func getPaymentMethod() {
        //        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        //        let config = STPPaymentConfiguration.shared()
        //
        //        let paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        //        paymentContext.paymentAmount = StripeCart.total
    }
    
    
    func switchToCustomerProfile() {
        let message = "By switiching to your Roamer Account, you will now begin to recive request to roam and earn cash on each completed delivery."
        let alert = UIAlertController(title: "Switch to Roamer Account", message: message, preferredStyle: UIAlertController.Style.alert)
        
        // SWITCH
        alert.addAction(UIAlertAction(title: "Switch Accounts", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.presentCustomerHomePage()
        }))
        
        // STAY HERE
        alert.addAction(UIAlertAction(title: "Stay Here", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        // present alert
        self.present(alert, animated: true , completion: nil)
        }
    
    func presentCustomerHomePage() {
        UserService.switchIsRoaming(to: "false")
        UserService.switchIsCustomer(to: "true")
        let storyBoard = UIStoryboard(name: StoryBoards.Main, bundle: nil)
        let tabBar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.customerTabBar) as! UITabBarController)

        self.present(tabBar!, animated: true, completion: nil)
        
    }
    
    /***************************************/
    /********** Log Out Roamer ************/
    /*************************************/
    
    func presentLoginController() {
        let storyboard = UIStoryboard(name: StoryBoards.Main, bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        present(controller!, animated: true, completion: nil)
    }
    
    func logOutUser() {
        UserService.dispatchGroup.notify(queue: .main, execute: {
            
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    UserService.logoutUser() // removes event listener from fb user reference
                    self.presentLoginController()
                } catch {
                    UserService.switchIsRoaming(to: "true") // to enable notif
                    UserService.switchIsCustomer(to: "false")
                    let message = "There was an issue logging out. Please try again."
                    self.displayError(title: "Whoops.", message: message)
                }
            }
            else {
                print("there was no one logged in")
                self.presentLoginController()
            }
        })
    }
    
    
    func beginLogOut() {
        let message = "Are you sure you would like to log out?"
        let alert = UIAlertController(title: "Log Out", message: message, preferredStyle: UIAlertController.Style.alert)
        
        // LOGOUT
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            UserService.dispatchGroup.enter()
            UserService.switchIsRoaming(to: "false") // to disable notif
            UserService.switchIsCustomer(to: "true")

            self.logOutUser()
        }))
        
        // STAY LOGGED IN
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        // present alert
        self.present(alert, animated: true , completion: nil)
    }
    
    
}

extension RoamerProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Basic Info
            return 1
        case 1: // display name, user name, email, phone
            return 4
        case 2: // Account Info
            return 1
        case 3: // payment info
            return 5
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        getPaymentMethod()
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileSectionCell) as! ProfileSectionCell
            cell.sectionTitle.text = "Basic Info"
            cell.sectionImage.image = UIImage(named: "pencil")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileInfoCell) as! ProfileInfoCell
            switch row {
            case 0:
                cell.infoTitle.text = "Display Name"
                cell.infoDescription.text = "MyName"
                return cell
            case 1:
                cell.infoTitle.text = "Name"
                cell.infoDescription.text = "\(UserService.user.firstName) \(UserService.user.lastName)"
                return cell
            case 2:
                cell.infoTitle.text = "Email"
                cell.infoDescription.text = "\(UserService.user.email)"
                return cell
            case 3:
                cell.infoTitle.text = "Phone"
                cell.infoDescription.text = "(925)848-8888"
                return cell
            default:
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileSectionCell) as! ProfileSectionCell
            cell.sectionTitle.text = "Account Info"
            cell.sectionImage.image = nil
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ProfileInfoCell) as! ProfileInfoCell
            switch row {
            case 0:
                cell.infoTitle.text = "Payment Info"
                cell.infoDescription.text = "Visa"
                return cell
            case 1:
                cell.infoTitle.text = "Roaming Status"
                cell.infoDescription.text = "Active"
                cell.accessoryType = .disclosureIndicator
                return cell
            case 2:
                cell.infoTitle.text = "Switch to customer profile"
                cell.infoDescription.text = ""
                cell.accessoryType = .disclosureIndicator
                return cell
            case 3:
                cell.infoTitle.text = "Log Out"
                cell.infoDescription.text = ""
                cell.infoTitle.textColor = #colorLiteral(red: 0.7788676168, green: 0.1122596166, blue: 0.07396716866, alpha: 1)
                cell.accessoryType = .disclosureIndicator
                return cell
            case 4:
                cell.infoTitle.text = ""
                cell.infoDescription.text = ""
                return cell
            default:
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        print(section, row)
        switch section {
        case 3:
            switch row {
                
            case 1: // Change Roaming Status
                let changeRoamingStatusVC = ChangeRomingStatusController()
                
                changeRoamingStatusVC.modalTransitionStyle = .crossDissolve
                changeRoamingStatusVC.modalPresentationStyle = .overCurrentContext
                tabBarController?.present(changeRoamingStatusVC, animated: true, completion: nil)
            case 2: // switch to customer profile
                switchToCustomerProfile()
            case 3: // Log Out
                self.beginLogOut()
                print("log out clicked")
            default:
                print("row \(row)")
            }
            
        default:
            print("section \(section)")
        }
    }
}


/***********************************************/
/********** Handle Profile Picture ************/
/*********************************************/

extension RoamerProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // returns a HUGE image -> like 10mb
        if let image = info[.editedImage] as? UIImage {
            let size = CGSize(width: 175, height: 175)
            let scaledImage = image.af_imageAspectScaled(toFill: size)
            profilePictureView.image = scaledImage
            
            uploadImageToFirebase(withImage: scaledImage)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(withImage image: UIImage) {
        let uploadData = image.pngData()!
        let storageRef = Storage.storage().reference().child(UserService.user.email)
        
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                self.displayError(error: error)
            }
            
            print(metadata)
            
        }
    }
    
    func tryToGetProfilePic() {
        let storageRef = Storage.storage().reference().child(UserService.user.email)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                self.profilePictureView.image = UIImage(data: data!)
            }
        }
    }
    
    @objc @IBAction func cameraClicked(_ sender: Any) {
        let alert = UIAlertController()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                // open up the camera
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
            // open photo library
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}
