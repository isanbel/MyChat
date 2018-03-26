//
//  ChatPageTableViewController+FriendPreference.swift
//  MyChat
//
//  Created by Raincome on 26/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

extension ChatPageTableViewController {
    func friendPreference() {
        switch (self.friend.attributename!) {
        case "email":
            new_friend = Postman()
            break
        default:
            return
        }
        self.is_preferencing = true
        friendSendsMessage(new_friend.hello!)
        if (new_friend.preference_count_total > 0) {
            let first_message = new_friend.preference_array[0]
            friendSendsMessage(new_friend.preference_message[first_message]!)
            new_friend.preference_count_current! += 1
        }
    }
    
    func friendSendsMessage(_ message_sent: String) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // save date indicator if last message is nil or 5 min ago
            if let lastmessageDate = friend.lastMessage?.date {
                if lastmessageDate.timeIntervalSinceNow < -300 {
                    let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                    dateIndicator.date = Date()
                    dateIndicator.contentText = ""
                    dateIndicator.friend = friend
                    dateIndicator.isDateIdentifier = true
                    appendMessageAndShow(message: dateIndicator)
                }
            } else {
                let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                dateIndicator.date = Date()
                dateIndicator.contentText = ""
                dateIndicator.friend = friend
                dateIndicator.isDateIdentifier = true
                appendMessageAndShow(message: dateIndicator)
            }
            
            let message = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
            message.isSent = false
            message.date = Date()
            message.contentText = message_sent
            message.friend = friend
            message.isDateIdentifier = false
            
            // delete the old last message and add the new one
            let context = appDelegate.persistentContainer.viewContext
            if friend.lastMessage != nil {
                context.delete(friend.lastMessage!)
            }
            
            // 更新 lastMessage
            let lastmessage = LastMessageMO(context: appDelegate.persistentContainer.viewContext)
            lastmessage.content = textField.text!
            lastmessage.date = Date()
            friend.lastMessage = lastmessage
            
            // 保存发送的信息
            appDelegate.saveContext()
            appendMessageAndShow(message: message)
        }
    }
    
    func saveToFriendPreference() {
        let last_message = new_friend.preference_array[new_friend.preference_count_current - 1]
        let preference = textField.text!
        new_friend.preference[last_message].string = preference
        if (new_friend.preference_count_current < new_friend.preference_count_total) {
            let new_message = new_friend.preference_array[new_friend.preference_count_current]
            new_friend.preference_count_current! += 1
            friendSendsMessage(new_friend.preference_message[new_message]!)
        } else {
            is_preferencing = false
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                friend.preference = new_friend.preference.rawString()
                appDelegate.saveContext()
            }
            // 将配置信息发送到服务器
            uploadPreference()
        }
    }
    
    func uploadPreference() {
        let url = "/friends" + friend.id! + "/preference"
        let parameters: [String: Any] = new_friend.preference!.dictionaryObject!
        waitForResponseFromServer(url: url, parameters: parameters)
    }
}
