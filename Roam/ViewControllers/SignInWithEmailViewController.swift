//
//  SignInWithEmailViewController.swift
//  Roam
//
//  Created by chinenye ogbuchiekwe on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Parse

class SignInWithEmailViewController: UIViewController {

    @IBOutlet weak var emailFieldOutlet: UITextField!
    @IBOutlet weak var passwordFieldOutlet: UITextField!
    
    
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = emailFieldOutlet.text
        user.password = passwordFieldOutlet.text
        user.signUpInBackground { (success, error) in
            if success{
        self.performSegue(withIdentifier: "toHomePage", sender: nil)
            }else{
                print("error occured \(error)")
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
