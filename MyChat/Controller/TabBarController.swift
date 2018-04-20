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
        // tabbar.layer.borderWidth = 0.50
        // tabbar.layer.borderColor = UIColor.clear.cgColor
        // tabbar.clipsToBounds = true
        
        // init update
        updateUnreadMessages()
        setDelegate()
    }
}

extension TabBarController: TabbarDelegate {
    
    func setDelegate() {
        ChatTableViewController.noticeDelegate = self
        ContactCollectionViewController.noticeDelegate = self
    }
    
    func updateUnreadMessages() {
        var unreadCount = 0
        for friend in Global.user.friends!.array as! [FriendMO] {
            if let unreadCountOne = friend.lastMessage?.unreadCount {
                unreadCount = unreadCount + Int(unreadCountOne)
            }
        }
        print("开始更新tab了，总数是\(unreadCount)")
        tabbar.items![0].badgeValue = unreadCount == 0 ? nil : String(unreadCount)
        Global.badgeValue = Int32(unreadCount)
    }
}
