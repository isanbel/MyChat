//
//  Friend.swift
//  MyChat
//
//  Created by Raincome on 20/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import SwiftyJSON

class FriendBase {
    var attribute_name: String!
    var hello: String!
    var preference_count_total: Int!
    var preference_count_current: Int!
    var preference_message: [String: String]!
    var preference_array: [String]!
    var preference: JSON!
}
