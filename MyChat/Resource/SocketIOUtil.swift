//
//  SocketIO.swift
//  MyChat
//
//  Created by Raincome on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import SocketIO

class SocketIOUtil {
    static let BASE_URL: String = "http://127.0.0.1:3000"
    static var manager: SocketManager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!, config: [.log(true), .compress])
    static var socket: SocketIOClient = manager.socket(forNamespace: "/schedule")
    
    static func initialize() {
        
        socket.on("connect", callback: { (data, ack) in
            print(data)
            print(ack)
            socket.emit("start", ["time": 10, "thing": "test"])
        })
        
        socket.on("error", callback: { (data, ack) in
            print(data)
            print(ack)
        })
        
        socket.connect()
        
    }
}
