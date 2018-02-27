//
//  ChatTableCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class ChatOutline {
    var avatar: String
    var name: String
    var chatSlice: String
    var date: String
    var stickOnTop: Bool

    init( name: String, avatar: String, chatSlice: String, date: String, stickOnTop: Bool) {
        self.name = name
        self.avatar = avatar
        self.chatSlice = chatSlice
        self.date = date
        self.stickOnTop = stickOnTop
    }

    convenience init() {
        self.init(name: "", avatar: "", chatSlice: "", date: "", stickOnTop: false)
    }
}
