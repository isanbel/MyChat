//
//  TabBarViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 18/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbar.layer.borderWidth = 0.50
        tabbar.layer.borderColor = UIColor.clear.cgColor
        tabbar.clipsToBounds = true
    }
}
