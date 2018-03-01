//
//  ChatPageTableViewCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 01/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class ChatPageReceiveTableViewCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var contentLabel: UILabel! {
        didSet {
            contentLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
