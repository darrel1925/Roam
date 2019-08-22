//
//  MainViewController.swift
//  Roam
//
//  Created by chinenye ogbuchiekwe on 8/13/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        let V1 = self.storyboard?.instantiateViewController(withIdentifier: "V1") as UIViewController?
        
        self.addChild(V1!)
        self.scrollView.addSubview(V1!.view)
        V1?.didMove(toParent: self)
        V1?.view.frame = scrollView.bounds
        
        
        
        let V2 = self.storyboard?.instantiateViewController(withIdentifier: "V2") as UIViewController?
        
        self.addChild(V2!)
        self.scrollView.addSubview(V2!.view)
        V2?.didMove(toParent: self)
        V2?.view.frame = scrollView.bounds
        
        var V2Frame: CGRect = (V2?.view.frame)!
        V2Frame.origin.x = self.view.frame.width
        V2?.view.frame = V2Frame
        
        
        
        let V3 = self.storyboard?.instantiateViewController(withIdentifier: "V3") as UIViewController?
        
        self.addChild(V3!)
        self.scrollView.addSubview(V3!.view)
        V3?.didMove(toParent: self)
        V3?.view.frame = scrollView.bounds
        
        
        var V3Frame: CGRect = (V3?.view.frame)!
        V3Frame.origin.x = 2 * self.view.frame.width
        V3?.view.frame = V3Frame
        
        //        if scrollView.tag == 10 {
        //
        //            self.scrollView.contentSize = CGSize( width: (self.view.frame.width) * 3, height: (self.view.frame.height))
        //        }
        self.scrollView.contentSize = CGSize( width: (self.view.frame.width) * 3, height: (self.view.frame.height))
        
        
        self.scrollView.contentOffset = CGPoint(x: (self.view.frame.width) * 1, y: (self.view.frame.height))
        
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
