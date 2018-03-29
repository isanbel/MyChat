//
//  ChatTableViewController+NewMessage.swift
//  MyChat
//
//  Created by Raincome on 28/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

extension ChatTableViewController: SocketIODelegate {
    
    func setDelegate() {
        SocketIOUtil.delegate = self
    }
    
    func revieveMessage(message: String, from: String) {
        print("在列表收到了：\(message)")
    }
    
    func checkUnreadMessgae() {
        for lm in lastMessages {
            if (Global.unread_messages.keys.contains(lm.friend!.id!)) {
                // TODO: 把未读消息 lm 显示，并加小红点
            }
        }
    }
}
