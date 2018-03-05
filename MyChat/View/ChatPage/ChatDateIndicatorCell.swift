//
//  DateIndicatorCell.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 02/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class ChatDateIndicatorCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel! {
        didSet {
            self.selectionStyle = .none
            // TODO: height
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
