//
//  ChatTableCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class LastMessage {
    var friendId: String
    var avatar: String
    var name: String
    var content: String
    var date: Date
    var stickOnTop: Bool

    init(friendId: String, name: String, avatar: String, content: String, date: Date) {
        self.friendId = friendId
        self.name = name
        self.avatar = avatar
        self.content = content
        self.date = date
        self.stickOnTop = false
    }

    convenience init() {
        self.init(friendId: "", name: "", avatar: "", content: "", date: Date())
    }

    func stick() {
        self.stickOnTop = true
    }
    
    func unstick() {
        self.stickOnTop = false
    }
}
