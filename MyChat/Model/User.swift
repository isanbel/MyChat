//
//  User.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

enum Gender {
    case Male
    case Female
}

class User {
    var id: String
    var name: String
    var email: String
    var password: String
    var avatar: String
    var gender: Gender?
    var birthday: Date?

    init(id: String, name: String, email: String, password: String, avatar: String, gender: Gender?, birthday: Date?) {
        self.id = id
        self.name = name
        self.gender = gender
        self.birthday = birthday
        self.avatar = avatar
        self.email = email
        self.password = password
    }

    convenience init() {
        self.init(id: "", name: "", email: "", password: "", avatar: "", gender: nil, birthday: nil)
    }
}
