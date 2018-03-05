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
    var isMale: Bool
    var birthday: Date
    
    init(id: String, name: String, avatar: String, isMale: Bool, birthday: Date) {
        self.id = id
        self.name = name
        self.isMale = isMale
        self.birthday = birthday
        self.avatar = avatar
    }
    
    convenience init() {
        self.init(id: "", name: "", avatar: "", isMale: true, birthday: Date())
    }
}

