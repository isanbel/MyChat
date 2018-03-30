//
//  TodayHeaderTableViewCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 30/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class TodayHeaderTableViewCell: UITableViewHeaderFooterView {
    static let reuseIdentifer = "TodayHeaderTableViewCell"

    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    override public init(reuseIdentifier: String?) {
        self.titles = []
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    var titles: [String] {
        didSet {
            titleLabel.text = titles[0]
            subTitleLabel.text = titles[1]
            
            self.contentView.addSubview(subTitleLabel)
            self.contentView.addSubview(titleLabel)
            self.contentView.backgroundColor = UIColor(hex: "#eeeeee")
            
            let subTitleColor = UIColor(hex: "#777777")
            let titleColor = UIColor(hex: "#222222")
            
            let subTitleAttr = [NSAttributedStringKey.foregroundColor: subTitleColor]
            subTitleLabel.attributedText = NSAttributedString(string: subTitleLabel.text!, attributes: subTitleAttr)
            subTitleLabel.frame = CGRect(x: 20, y: 0, width: 200, height: 40)
            
            let titleAttr = [NSAttributedStringKey.foregroundColor: titleColor, NSAttributedStringKey.font: UIFont(name: "PingFangSC-Medium", size: 26)]
            titleLabel.attributedText = NSAttributedString(string: titleLabel.text!, attributes: titleAttr)
            titleLabel.frame = CGRect(x: 20, y: 30, width: 200, height: 40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

