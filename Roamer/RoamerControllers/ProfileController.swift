//
//  ProfileController.swift
//  Roam
//
//  Created by Darrel Muonekwu on 8/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import FirebaseStorage
import AlamofireImage

class ProfileController: UIViewController {
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
    


}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
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
            return 1
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
                cell.infoTitle.text = "User Name"
                cell.infoDescription.text = "@\(UserService.user.username)"
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
            default:
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}


extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
