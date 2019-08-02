//
//  HomePageViewController.swift
//  Roam
//
//  Created by Kay Lab on 5/18/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // add all of our info to our User class to use globally
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        }
    }
    
    func presentLoginController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                // removes event listener from fb user reference
                UserService.logoutUser()
                presentLoginController()
            } catch {
                // TOTO: show error message
                print("could not log out")
            }
        }
        else {
            presentLoginController()
        }
    }
    
    @IBAction func cartClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CheckOutVC = storyboard.instantiateViewController(withIdentifier: "CheckOutController")
        self.navigationController?.present(CheckOutVC, animated: true, completion: {
            print("CheckOutVC Presented")
        })
    }
}
