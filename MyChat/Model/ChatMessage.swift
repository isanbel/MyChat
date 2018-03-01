//
//  ChatMessage.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 01/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

enum MsgType {
    case Sent
    case Received
}

class ChatMessage {
    var msgType: MsgType
    var contentText: String?
    // TODO: voice, video content
    var date: Date
    // one message can be a date indicator above another message too.
    var isDateIndicator: Bool

    init(msgType: MsgType, contentText: String?) {
        self.msgType = msgType
        self.contentText = contentText
        self.date = Date()
        self.isDateIndicator = false
    }

    convenience init() {
        self.init(msgType: MsgType.Sent, contentText: nil)
    }
    
    func beDateIndicatorAbove(aChatMessage: ChatMessage) {
        // be 10 ms earlier than aChatMessage date
        self.date = Date(timeInterval: -0.010, since: aChatMessage.date)
        self.isDateIndicator = true
    }
}
