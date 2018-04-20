//
//  Global.swift
//  MyChat
//
//  Created by Raincome on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import UIKit

class Global {
    static var user: UserMO = UserMO()
    static var userid: String?
    static var navbar_bgc: UIColor = UIColor(displayP3Red: 81/255, green: 125/255, blue: 186/255, alpha: 1)
    static var unread_messages = [String:[String]]()
    static var badgeValue = 0
}
