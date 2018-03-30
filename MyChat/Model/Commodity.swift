//
//  Commodity.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 30/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

class Commodity {
    var id: String
    var name: String
    var title: String
    var subTitle: String
    var image: UIImage
    var price: Int
    var releaseDate: Date
    var developor: String
    
    init(id: String, name: String, title: String, subTitle: String, image: UIImage, price: Int, releaseDate: Date, developor: String) {
        self.id = id
        self.name = name
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.price = price
        self.releaseDate = releaseDate
        self.developor = developor
    }
    
    convenience init() {
        self.init(id: "", name: "", title: "", subTitle: "", image: UIImage(), price: 0, releaseDate: Date(), developor: "")
    }
}
