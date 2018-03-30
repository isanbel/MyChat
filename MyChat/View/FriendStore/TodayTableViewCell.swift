//
//  TodayTableViewCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 30/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCALE_RATE: CGFloat = 1.2

class TodayTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var containerView = UIImageView()
    var largeImageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var todayCommodity: TodayCommodity? {
        didSet {
            // 先移除，再添加，避免cell复用时候重复添加视图
            self.containerView.removeFromSuperview()
            self.largeImageView.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
            self.subTitleLabel.removeFromSuperview()
            self.contentView.addSubview(self.containerView)
            self.containerView.addSubview(self.largeImageView)
            self.containerView.addSubview(self.titleLabel)
            self.containerView.addSubview(self.subTitleLabel)

            // set data
            largeImageView.image = todayCommodity?.image
            titleLabel.text = todayCommodity?.title
            subTitleLabel.text = todayCommodity?.subTitle
            
            self.containerView.frame = CGRect(x: 20, y: 20, width: SCREEN_WIDTH - 40, height: SCREEN_WIDTH * SCALE_RATE - 40)
            self.containerView.backgroundColor = .white
            
            largeImageView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 40, height: SCREEN_WIDTH * SCALE_RATE - 40)
            
            self.largeImageView.layer.cornerRadius = 20
            self.largeImageView.clipsToBounds = true
            
            self.containerView.layer.cornerRadius = 20
            self.containerView.clipsToBounds = true
            self.contentView.backgroundColor = UIColor(hex: "#eeeeee")
            
            // shadow
            self.containerView.layer.masksToBounds = false
            self.containerView.layer.shadowColor = UIColor.black.cgColor
            self.containerView.layer.shadowOpacity = 0.08
            self.containerView.layer.shadowOffset = .zero
            self.containerView.layer.shadowRadius = 10
            
            let subTitleAttr = [NSAttributedStringKey.foregroundColor: UIColor(hex: "#bcbcbc")]
            subTitleLabel.attributedText = NSAttributedString(string: subTitleLabel.text!, attributes: subTitleAttr)
            subTitleLabel.frame = CGRect(x: 20, y: 18, width: 200, height: 40)
            
            let titleAttr = [NSAttributedStringKey.foregroundColor: UIColor(hex: "#ffffff"), NSAttributedStringKey.font: UIFont(name: "PingFangSC-Regular", size: 30)]
            titleLabel.attributedText = NSAttributedString(string: titleLabel.text!, attributes: titleAttr)
            titleLabel.frame = CGRect(x: 20, y: 50, width: 200, height: 40)
            
        }
    }
}

