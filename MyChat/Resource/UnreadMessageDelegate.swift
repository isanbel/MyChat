//
//  NewMessageDelegate.swift
//  MyChat
//
//  Created by Raincome on 2018/4/20.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

import Foundation

protocol UnreadMessageDelegate: NSObjectProtocol {
    func fetchUnreadMessages()
}
