//
//  Friend.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 05/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class Friend {
    var id: String
    var name: String
    var avatar: String
    var gender: Gender?
    var birthday: Date?
    
    init(id: String, name: String, avatar: String, gender: Gender?, birthday: Date?) {
        self.id = id
        self.name = name
        self.gender = gender
        self.birthday = birthday
        self.avatar = avatar
    }
    
    convenience init() {
        self.init(id: "", name: "", avatar: "", gender: nil, birthday: nil)
    }
    
    func setGender(gender: Gender?) {
        self.gender = gender
    }
    
    func setBirthday(birthday: Date?) {
        self.birthday = birthday
    }
}

