//
//  FriendManagementTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 08/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class FriendManagementTableViewController: UITableViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mychatidLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    
    var friend = FriendMO()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(displayP3Red: 237/255, green: 235/255, blue: 235/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    func loadData() {
        nameLabel.text = friend.name
        mychatidLabel.text = friend.id
        if let avatarImage = friend.avatar {
            avatarImageView.image = UIImage(data: avatarImage as Data)
        }
        
    }

}
