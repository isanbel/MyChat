//
//  TodayCommodity.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 30/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class TodayCommodity {
    var id: String
    var title: String
    var subTitle: String
    var image: UIImage
    var price: Int
    var date: Date
    
    init(id: String, title: String, subTitle: String, image: UIImage, price: Int, date: Date) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.price = price
        self.date = date
    }
    
    convenience init() {
        self.init(id: "", title: "", subTitle: "", image: UIImage(), price: 0, date: Date())
    }
}
