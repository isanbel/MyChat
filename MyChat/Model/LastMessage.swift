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
    var content: String
    var date: Date
    var stickOnTop: Bool

    init(friendId: String, content: String, date: Date) {
        self.friendId = friendId
        self.content = content
        self.date = date
        self.stickOnTop = false
    }

    convenience init() {
        self.init(friendId: "", content: "", date: Date())
    }

    func stick() {
        self.stickOnTop = true
    }
    
    func unstick() {
        self.stickOnTop = false
    }
}
