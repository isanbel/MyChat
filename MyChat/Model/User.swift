//
//  User.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class User {
    var userId: String
    var name: String
    var gender: String
    var birthday: Date
    var avatar: String
    var email: String
    var password: String

    init(userId: String, name: String, gender: String, birthday: Date, avatar: String, email: String, password: String) {
        self.userId = userId
        self.name = name
        self.gender = gender
        self.birthday = birthday
        self.avatar = avatar
        self.email = email
        self.password = password
    }

    convenience init() {
        self.init(userId: "", name: "", gender: "", birthday: Date(), avatar: "", email: "", password: "")
    }
}
