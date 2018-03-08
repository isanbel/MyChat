//
//  ContactTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 05/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    var friends: [FriendMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(displayP3Red: 237/255, green: 235/255, blue: 235/255, alpha: 1)
        
        getFriends()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let friendsCount = friends.count
        loadData()
        // reload when table changes
        if friendsCount != friends.count {
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ContactTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactTableViewCell
        
        cell.nameLabel.text = friends[indexPath.row].name
        if let avatarImage = friends[indexPath.row].avatar {
            cell.thumbnailImageView.image = UIImage(data: avatarImage as Data)
        }
        
        return cell
    }    
    
    func loadData() {
        print("== count of friends \(String(describing: Global.user.friends?.count))")
        friends = Global.user.friends?.array as! [FriendMO]
    }
    
    func getFriends() {
        let url: String = "/friends?userid=" + Global.user.id!
        let onSuccess = { (data: [String: Any]) in
            print("== getFriends success")
            // TODO: save to store and then loadData
            self.loadData()
        }
        
        let onFailure = { (data: [String: Any]) in
            print("== getFriends failure")
        }
        HttpUtil.get(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendProfile" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! FriendProlileTableViewController
                destinationViewController.friend = friends[indexPath.row]
            }
        }
    }
    

}
