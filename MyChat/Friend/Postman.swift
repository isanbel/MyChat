//
//  Postman.swift
//  MyChat
//
//  Created by Raincome on 20/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import SwiftyJSON

class Postman: FriendBase {
    override init() {
        super.init()
        self.attribute_name = "compute"
        self.hello = "嘿，这是咱们第一次见面，你先得设置好邮箱账户才能使用此服务。"
        self.preference_count_total = 3
        self.preference_count_current = 0
        self.preference_array = ["vendor", "username", "password"]
        self.preference_message = [
            "vendor": "你用的是哪一家的Email？（目前支持：QQ邮箱）",
            "username": "你的Email账户是？",
            "password": "麻烦提供下你的第三方授权码。（请放心，我不会泄漏出去的）"
        ]
        self.preference = JSON()
    }
}
