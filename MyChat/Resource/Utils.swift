//
//  Utils.swift
//  MyChat
//
//  Created by Raincome on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Utils {
    static weak var delegate: UnreadMessageDelegate?
    
    static func getAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "哦", style: UIAlertActionStyle.default, handler: nil))
        return alertController
    }
    
    // 获取中文（或英文）的拼音的第一个字符
    static func findFirstLetterFromString(aString: String) -> String {
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: aString)
        
        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil,      kCFStringTransformToLatin, false)
        
        //去掉声调
        let pinyinString = mutableString.folding(options:          String.CompareOptions.diacriticInsensitive, locale:   NSLocale.current)
        
        //将拼音首字母换成大写
        let strPinYin = pinyinString.uppercased()
        
        //截取大写首字母
        let firstString = strPinYin.substring(to:     strPinYin.index(strPinYin.startIndex, offsetBy: 1))
        
        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        
        return predA.evaluate(with: firstString) ? firstString : "#"
    }

    static func initBaiduAccessToken() {
        let url = "https://aip.baidubce.com/oauth/2.0/token?"
            + "grant_type=" + Config.BAIDU_GRANT_TYPE + "&"
            + "client_id=" + Config.BAIDU_CLIENT_ID + "&"
            + "client_secret=" + Config.BAIDU_CLIENT_SECRET
        let onSuccess = { (data: [String: Any]) in
            let access_token = data["access_token"] as! String
            print("get baidu access token: \(access_token)")
            Config.BAIDU_ACCESS_TOKEN = access_token
        }
        let onFailure = {
            print("fail to get baidu access token")
            // TODO: 获取 Access Token 失败
        }
        HttpUtil.get_(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    static func lexicalAnalysis(text: String, onResult: @escaping([String: Any]) -> Void, onError: @escaping() -> Void) {
        let url = "https://aip.baidubce.com/rpc/2.0/nlp/v1/lexer?access_token=" + Config.BAIDU_ACCESS_TOKEN + "&charset=UTF-8"
        let parameters = [
            "text": text
        ]
        HttpUtil.post_(url: url, parameters: parameters, onSuccess: onResult, onFailure: onError)
    }
    
    static func showNotification(title: String, subtitle: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title;
        content.subtitle = subtitle;
        content.body = body;
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "mychat", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("**********************")
    }
    
    static func appendDateIndicatorIfNeeded(whenChattingWith friend: FriendMO) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // save date indicator if last message is nil or 5 min ago
            if let lastmessageDate = friend.lastMessage?.date {
                if lastmessageDate.timeIntervalSinceNow < -300 {
                    let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                    dateIndicator.date = Date()
                    dateIndicator.contentText = ""
                    dateIndicator.friend = friend
                    dateIndicator.isDateIdentifier = true
                }
            } else {
                let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                dateIndicator.date = Date()
                dateIndicator.contentText = ""
                dateIndicator.friend = friend
                dateIndicator.isDateIdentifier = true
            }
            appDelegate.saveContext()
        }
    }
    
    static func fetchAllNewMessages() {
        let userid = Global.user.id!
        let url = "/unread_messages/all?userid=\(userid)"
        let onSuccess = { (data: [String: Any]) in
            let unread_messages = data["unread_messages"] as! [[String: Any]]
            if unread_messages.count == 0 { return }
            for um in unread_messages {
                let friendid = um["friendid"] as! String
                let messages = um["messages"] as! [String]
                if (!Global.unread_messages.keys.contains(friendid) && messages.count > 0) {
                    Global.unread_messages[friendid] = [String]()
                }
                for m in messages {
                    Global.unread_messages[friendid]!.append(m)
                }
            }
            delegate!.fetchUnreadMessages()
            // UIApplication.shared.applicationIconBadgeNumber = Int(Global.badgeValue)
        }
        let onFailure = { (data: [String: Any]) in }
        HttpUtil.get(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    static func fetchFriendNewMessages(friendid: String) {
        let userid = Global.user.id!
        let url = "/unread_messages/one?userid=\(userid)&friendid=\(friendid)"
        let onSuccess = { (data: [String: Any]) in
            let unread_messages = data["unread_messages"] as! [[String: Any]]
            if unread_messages.count == 0 { return }
            if (!Global.unread_messages.keys.contains(friendid)) {
                Global.unread_messages[friendid] = [String]()
            }
            for um in unread_messages {
                let messages = um["messages"] as! [String]
                for m in messages {
                    Global.unread_messages[friendid]!.append(m)
                }
            }
            delegate!.fetchUnreadMessages()
            // UIApplication.shared.applicationIconBadgeNumber = Int(Global.badgeValue)
        }
        let onFailure = { (data: [String: Any]) in }
        HttpUtil.get(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
}
