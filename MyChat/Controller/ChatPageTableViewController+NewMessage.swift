//
//  ChatPageTableViewController+NewMessage.swift
//  MyChat
//
//  Created by Raincome on 28/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

extension ChatPageTableViewController: SocketIODelegate {
    
    func setDelegate() {
        SocketIOUtil.delegate = self
    }
    
    func revieveMessage(message: String, from: String) {
        if (from == friend.id) {
            friendSendsMessage(message)
        } else {
            if (!Global.unread_messages.keys.contains(from)) {
                Global.unread_messages[from] = [String]()
            }
            Global.unread_messages[from]!.append(message)
        }
    }
    
    func checkUnreadMessgae() {
        let friendid = friend.id!
        if (Global.unread_messages.keys.contains(friendid)) {
            let messages = Global.unread_messages[friendid]!
            for message in messages {
                friendSendsMessage(message)
            }
        }
    }
}
