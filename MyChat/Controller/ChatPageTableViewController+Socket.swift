//
//  ChatPageTableViewController+Socket.swift
//  MyChat
//
//  Created by Raincome on 2018/4/4.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import SocketIO

extension ChatPageTableViewController {
    func initSocket() {
        let url = SocketIOUtil.getUrlByAttributename(attributename: friend.attributename!)
        print(url)
        socket_manager = SocketManager(socketURL: URL(string: url)!, config: [.log(true), .compress])
        socket = socket_manager.socket(forNamespace: "/")
        socket.on("connect", callback: { (data, ack) in
            print(data)
            self.socket.emit("hello", ["userid": Global.user.id!])
        })
        socket.on("message", callback: { (data, ack) in
            print(data)
            let temp = data[0] as! [String: Any]
            let message = temp["message"] as! String
            self.friendSendsMessage(message)
        })
        socket.on("messages", callback: { (data, ack) in
            print(data)
            let temp = data[0] as! [String: Any]
            let messages = temp["messages"] as! [String]
            for message in messages {
                self.friendSendsMessage(message)
            }
        })
        socket.connect()
    }
    
    func socketSend(message: String) {
        socket.emit("message", [
            "userid": Global.user.id!,
            "message": message
        ])
    }
}
