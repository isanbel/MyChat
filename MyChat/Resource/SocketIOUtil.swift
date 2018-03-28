//
//  SocketIO.swift
//  MyChat
//
//  Created by Raincome on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import SocketIO

class SocketIOUtil {
    // static let BASE_URL: String = "http://192.168.2.179:3000"
    static let BASE_URL: String = "http://127.0.0.1:3000"
    static var manager: SocketManager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    static var socket: SocketIOClient = manager.socket(forNamespace: "/")
    static weak var delegate: SocketIODelegate?
    
    static func initialize() {
        
        socket.on("connect", callback: { (data, ack) in
            print(data)
            print(ack)
            socket.emit("start", ["userid": Global.user.id!])
        })
        
        socket.on("error", callback: { (data, ack) in
            print(data)
            print(ack)
        })
        
        socket.on("message", callback: { (data, ack) in
            delegate!.revieveMessage(message: "test", from: "test")
        })
        
        socket.connect()
    }
}
