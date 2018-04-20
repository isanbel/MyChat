//
//  ContactCollectionViewController+UnreadMessages.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 2018/4/20.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

extension ContactCollectionViewController: UnreadMessageDelegate {
    
    func setUnreadMessagesDelegate() {
        Utils.delegate = self
    }
    
    func fetchUnreadMessages() {
        let unread_messages = Global.unread_messages
        for unread_message in unread_messages {
            saveUnreadMessages(messages: unread_message.value, from: unread_message.key)
        }
        // update UI
        self.viewWillAppear(false)
        print("更新了table")
        // update Tabbar
        ChatTableViewController.noticeDelegate?.updateUnreadMessages()
    }
}
