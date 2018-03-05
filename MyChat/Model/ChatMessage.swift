//
//  ChatMessage.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 01/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class ChatMessage {
    var isSent: Bool
    var contentText: String
    // TODO: voice, video content
    var date: Date
    // one message can be a date indicator above another message too.
    var isDateIndicator: Bool

    init(isSent: Bool, contentText: String) {
        self.isSent = isSent
        self.contentText = contentText
        self.date = Date()
        self.isDateIndicator = false
    }
    
    init(isDateIndicator: Bool) {
        self.isSent = true
        self.contentText = ""
        self.date = Date()
        self.isDateIndicator = isDateIndicator
    }

    convenience init() {
        self.init(isSent: true, contentText: "")
    }
}
