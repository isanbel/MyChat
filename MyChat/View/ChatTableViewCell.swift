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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
