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
    
    @IBOutlet var badge: UILabel! {
        didSet {
            if badge.text! == "" || badge.text! == "0" {
                badge.isHidden = true
                return
            }
            // a simplest way to padding, but it's bad
            badge.text = " " + badge.text! + "  "
            badge.backgroundColor = .red
            badge.textColor = .white
            badge.textAlignment = .center
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
        super.init(coder: aDecoder)
    }
}
