//
//  SocketIODelegate.swift
//  MyChat
//
//  Created by Raincome on 28/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

protocol SocketIODelegate: NSObjectProtocol {
    func revieveMessage(message: String, from: String)
}
