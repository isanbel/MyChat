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
            // 将未读消息存到本地数据库
            saveUnreadMessages(messages: messages, from: from)
            // TODO: 左上角显示未读提示
        }
    }
    
    func saveUnreadMessages(messages: [String], from: String) {
        var friend = FriendMO()
        for friendTemp in Global.user.friends!.array as! [FriendMO] {
            if friendTemp.id == from {
                friend = friendTemp
                break
            }
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            for msg in messages {
                let message = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                message.isSent = false
                message.date = Date()
                message.contentText = msg
                message.friend = friend
                message.isDateIdentifier = false
                
                // delete the old last message and add the new one
                let context = appDelegate.persistentContainer.viewContext
                if friend.lastMessage != nil {
                    context.delete(friend.lastMessage!)
                }
                // update lastMessage
                let lastmessage = LastMessageMO(context: appDelegate.persistentContainer.viewContext)
                lastmessage.content = msg
                lastmessage.date = Date()
                lastmessage.unreadCount = lastmessage.unreadCount + 1
                friend.lastMessage = lastmessage
            }
            appDelegate.saveContext()
        }
    }
    
    func readUnreadMessages() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            friend.lastMessage?.unreadCount = 0
            appDelegate.saveContext()
        }
    }
}
