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
    var friendsDictionary: [String: [FriendMO]] = [:]
    var friendsSectionTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(displayP3Red: 237/255, green: 235/255, blue: 235/255, alpha: 1)
        tableView.sectionIndexBackgroundColor = .clear
        getFriends()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendsKey = friendsSectionTitles[section]
        if let friendsValues = friendsDictionary[friendsKey] {
            return friendsValues.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ContactTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactTableViewCell
        
        if let friendsValues = friendsDictionary[friendsSectionTitles[indexPath.section]] {
            cell.nameLabel.text = friendsValues[indexPath.row].name
            if let avatarImage = friendsValues[indexPath.row].avatar {
                cell.thumbnailImageView.image = UIImage(data: avatarImage as Data)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSectionTitles
    }
    
    func loadData() {
        print("== count of friends \(String(describing: Global.user.friends?.count))")
        friends = Global.user.friends?.array as! [FriendMO]
        getSortedFriendsDictionaryAndSectionTitles()
        tableView.reloadData()
    }
    
    func getFriends() {
        let url: String = "/friends?userid=" + Global.user.id!
        let onSuccess = { (data: [String: Any]) in
            print("== getFriends success")
            self.storeNewFriends(data: data)
            self.loadData()
        }
        
        let onFailure = { (data: [String: Any]) in
            print("== getFriends failure")
        }
        HttpUtil.get(url: url, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func storeNewFriends(data: [String: Any]) {
        let friends = data["data"] as! [[String: Any]]
        for friend in friends {
            
            var friendExisted = false
            let friendId = friend["friendid"]
            for oldFriend in Global.user.friends?.array as! [FriendMO] {
                // print("== \(oldFriend.id!) vs \(friendId!)")
                if oldFriend.id! == friendId as! String {
                    friendExisted = true
                    break
                }
            }
            
            // if friend exists
            if friendExisted == true {
                print("== it's old friend")
                continue
            }
            // else store this new friend
            print("== store new friend")
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                print("*********")
                let newFriend = FriendMO(context: appDelegate.persistentContainer.viewContext)
                newFriend.name = friend["friendname"] as? String
                newFriend.id = friend["friendid"] as? String
                newFriend.attributename = friend["attributename"] as? String
                
                // TODO: parse Date
                // newFriend.birthday
                
                // get avatar
                // TODO: use friendid to get avatar
                let avatarUrl = "http://139.199.174.146:3000/friendAvatar/" + newFriend.name! + ".png"
                let url = URL(string: avatarUrl)
                let avatar = try? Data(contentsOf: url!)
                newFriend.avatar = avatar
                
                newFriend.isMale = friend["friendid"] as? String == "male" ? true : false
                
                newFriend.user = Global.user
                
                print(newFriend)
                
                appDelegate.saveContext()
            }
        }
    }
    
    func getSortedFriendsDictionaryAndSectionTitles() {
        friendsDictionary = [:]
        for friend in friends {
            let key = Utils.findFirstLetterFromString(aString: friend.name!)
            if friendsDictionary[key] != nil {
                friendsDictionary[key]!.append(friend)
            } else {
                friendsDictionary[key] = [friend]
            }
        }
        // TODO: sort
        friendsSectionTitles = [String](friendsDictionary.keys)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendProfile" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! FriendProlileTableViewController
                destinationViewController.friend = friendsDictionary[friendsSectionTitles[indexPath.section]]![indexPath.row]
            }
        }
    }
    

}
