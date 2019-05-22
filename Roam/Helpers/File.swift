//
//  File.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import UIKit


class SettingsLauncher: NSObject {
    
    let blackView = UIView()
    let tableView = UITableView()

    func showSettings() {

        // entire applications window
        if let window = UIApplication.shared.keyWindow {
            // 0 = black  |  alpha = transpancy
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            // add blackView and tableView to the screen
            window.addSubview(blackView)
            window.addSubview(tableView)
            
            // format the size of black background
            blackView.frame = window.frame
            blackView.alpha = 0
            
            // format size of the tableView
            let height: CGFloat = 600
            let y = window.frame.height - height
                // window.frame.height is the bottom of the window aka the bottom of the screen
            tableView.frame = CGRect(x: 0, y: window.frame.height , width: window.frame.width, height: height)
            
            // this animation accelerates the animation fast in the begining and slower towards the end
                // of the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha  = 1
                self.tableView.frame =  CGRect(x: 0, y: y, width: self.tableView.frame.width, height: self.tableView.frame.height)
            }, completion: nil)
            
            // add Tap Gesture to dismiss the everything
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
        }
    }
    @objc func handleDismiss() {
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                
                self.tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
            }
        }
    }
    
    override init() {
        super.init()
        // start doing something here maybe
    }
}
