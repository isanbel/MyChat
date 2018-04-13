//
//  ChatTableViewCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var chatsliceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.layer.bounds.height / 2
            thumbnailImageView.clipsToBounds = true
        }
    }
    var badgeValue: Int {
        didSet {
            if badgeValue == 0 {
                badge.isHidden = true
            } else {
                badge.isHidden = false
                badge.text = "  " + String(badgeValue) + "  "
            }
        }
    }
    
    @IBOutlet var badge: UILabel! {
        didSet {
            // a simplest way to padding, but it's bad
            badge.backgroundColor = .red
            badge.textColor = .white
            badge.textAlignment = .left
            badge.layer.cornerRadius = badge.layer.bounds.height / 2
            badge.clipsToBounds = true
        }
    }
    
    @IBOutlet var stickyImageView: UIImageView! {
        didSet {
            stickyImageView.isHidden = stickOnTop ? false : true
        }
    }
    
    var stickOnTop: Bool {
        didSet {
            stickyImageView.isHidden = stickOnTop ? false : true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.stickOnTop = false
        badgeValue = 0
        super.init(coder: aDecoder)
    }
}
