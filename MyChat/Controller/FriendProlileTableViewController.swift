//
//  FriendProlileTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 05/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class FriendProlileTableViewController: UITableViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mychatidLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    
    var friend = FriendMO()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func loadData() {
        
        nameLabel.text = friend.name
        mychatidLabel.text = friend.id
        if let avatarImage = friend.avatar {
            avatarImageView.image = UIImage(data: avatarImage as Data)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatPage" {
            let destinationViewController = segue.destination as! ChatPageTableViewController
            destinationViewController.friend = friend
        }
    }

}
