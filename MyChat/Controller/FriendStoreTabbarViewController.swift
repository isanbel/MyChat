//
//  FriendStoreTabbarViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 29/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class FriendStoreTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(hex: "#278bfe")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        // reset to the app delegate setting
        navigationController?.navigationBar.barTintColor = Global.navbar_bgc
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        navigationController?.hidesBarsOnSwipe = false
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
