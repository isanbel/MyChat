//
//  SocketIO.swift
//  MyChat
//
//  Created by Raincome on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import SocketIO

class SocketIOUtil {
    static let BASE_URL: String = "http://\(Config.SERVER_IP):3000"
    static var manager: SocketManager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(false), .compress])
    static var socket: SocketIOClient = manager.socket(forNamespace: "/")
    static weak var delegate: SocketIODelegate?
    static var initialized = false
    
    static func initialize() {
        socket.on("connect", callback: { (data, ack) in
            print(data)
            print(ack)
            socket.emit("hello", ["userid": Global.user.id!])
            initialized = true
        })
        
        socket.on("error", callback: { (data, ack) in
            print(data)
            print(ack)
        })
        
        socket.on("message", callback: { (data, ack) in
            let temp = data[0] as! [String: Any]
            let friendid = temp["friendid"] as! String
            let message = temp["message"] as! String
            delegate!.recieveMessages(messages: [message], from: friendid)
        })
        
        socket.on("messages", callback: { (data, ack) in
            let temp = data[0] as! [String: Any]
            let friendid = temp["friendid"] as! String
            let messages = temp["messages"] as! [String]
            delegate!.recieveMessages(messages: messages, from: friendid)
        })
        
        socket.on("test-online", callback: { (data, ack) in
            socket.emit("test-online", ["userid": Global.user.id!])
        })

        socket.connect()
    }
    
    static func reportOnline() {
        if (!initialized) { return }
        socket.emit("online", ["userid": Global.user.id!])
    }
    
    static func reportOffline() {
        if (!initialized) { return }
        socket.emit("offline", ["userid": Global.user.id!])
    }
    
    static func getUrlByAttributename(attributename: String?) -> String {
        var url: String = "http://\(Config.SERVER_IP)"
        if attributename == nil {
            return url + ":3000"
        }
        switch (attributename!) {
        case "postman":
            url += ":3001"
            break
        case "calculator":
            url += ":3002"
            break
        case "translator":
            url += ":3003"
            break
        case "weather":
            url += ":3004"
            break
        case "mary":
            url += ":3005"
            break
        case "secretary":
            url += ":3006"
            break
        case "sanxing":
            url += ":3007"
            break
        case "accountant":
            url += ":3008"
            break
        case "express":
            url += ":3009"
            break
        case "mychat":
            url += ":3010"
            break
        case "gakki":
            url += ":3011"
            break
        default:
            url += ":3000"
        }
        return url
    }
}
