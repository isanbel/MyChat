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
        }
    }
}
