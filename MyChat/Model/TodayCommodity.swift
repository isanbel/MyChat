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
    var isLightMode: Bool
    
    init(id: String, title: String, subTitle: String, image: UIImage, price: Int, date: Date, isLightMode: Bool) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.price = price
        self.date = date
        self.isLightMode = isLightMode
    }
    
    convenience init() {
        self.init(id: "", title: "", subTitle: "", image: UIImage(), price: 0, date: Date(), isLightMode: true)
    }
}
