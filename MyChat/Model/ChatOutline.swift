//
//  ChatTableCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class ChatOutline {
    var friendId: String
    var avatar: String
    var name: String
    var chatSlice: String
    var date: Date
    var stickOnTop: Bool

    init(friendId: String, name: String, avatar: String, chatSlice: String, date: Date) {
        self.friendId = friendId
        self.name = name
        self.avatar = avatar
        self.chatSlice = chatSlice
        self.date = date
        self.stickOnTop = false
    }

    convenience init() {
        self.init(friendId: "", name: "", avatar: "", chatSlice: "", date: Date())
    }

    func stick() {
        self.stickOnTop = true
    }
    
    func unstick() {
        self.stickOnTop = false
    }
}
