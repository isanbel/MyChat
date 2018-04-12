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
    
    func recieveMessages(messages: [String], from: String) {
        if (from == friend.id) {
            for message in messages {
                self.friendSendsMessage(message)
            }
        } else {
//            if (!Global.unread_messages.keys.contains(from)) {
//                Global.unread_messages[from] = [String]()
//            }
//            Global.unread_messages[from]!.append(message)
            // 将未读消息存到本地数据库
            // TODO: 左上角显示未读提示
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
