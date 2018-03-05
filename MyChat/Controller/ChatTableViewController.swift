//
//  ChatTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {

    var lastMessages: [LastMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addTapped))

        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        // TODO: add plus button
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func addTapped() {
        print("add")
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
        return lastMessages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ChatTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatTableViewCell

        // Configure the cell...
        cell.nameLabel.text = lastMessages[indexPath.row].name
        cell.chatsliceLabel.text = lastMessages[indexPath.row].content
        // TODO: be the date parser, to the relative date to current date
        cell.dateLabel.text = lastMessages[indexPath.row].date.relativeTime
        cell.thumbnailImageView.image = UIImage(named: lastMessages[indexPath.row].avatar)

        return cell
    }

    // MARK: - UITableViewDelegate Protocol

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.lastMessages.remove(at: indexPath.row)

            self.tableView.deleteRows(at: [indexPath], with: .fade)

            // Call completion handler with true to indicate
            completionHandler(true)
        }

        // Customize the action buttons
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "delete")

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeConfiguration
    }

    func getData() {
        lastMessages = [
            LastMessage(friendId: "1", name: "Cafe Deadend", avatar: "cafedeadend.jpg", content: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", date: Date()),
            LastMessage(friendId: "1", name: "Homei", avatar: "homei.jpg", content: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", date: Date()),
            LastMessage(friendId: "1", name: "Teakha", avatar: "teakha.jpg", content: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", date: Date()),
            LastMessage(friendId: "1", name: "Cafe loisl", avatar: "cafeloisl.jpg", content: "Shop B, 20 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", date: Date()),
            LastMessage(friendId: "1", name: "Petite Oyster", avatar: "petiteoyster.jpg", content: "24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", date: Date()),
            LastMessage(friendId: "1", name: "For Kee Restaurant", avatar: "forkeerestaurant.jpg", content: "Shop J-K., 200 Hollywood Road, SOHO, Sheung Wan, Hong Kong", date: Date()),
            LastMessage(friendId: "1", name: "Po's Atelier", avatar: "posatelier.jpg", content: "G/F, 62 Po Hing Fong, Sheung Wan, Hong Kong", date: Date()),
            LastMessage(friendId: "1", name: "Bourke Street Backery", avatar: "bourkestreetbakery.jpg", content: "633 Bourke St Sydney New South Wales 2010 Surry Hills", date: Date()),
            LastMessage(friendId: "1", name: "Haigh's Chocolate", avatar: "haighschocolate.jpg", content: "412-414 George St Sydney New South Wales", date: Date()),
            LastMessage(friendId: "1", name: "Palomino Espresso", avatar: "palominoespresso.jpg", content: "Shop 1 61 York St Sydney New South Wales", date: Date()),
            LastMessage(friendId: "1", name: "Upstate", avatar: "upstate.jpg", content: "95 1st Ave New York, NY 10003", date: Date()),
            LastMessage(friendId: "1", name: "Traif", avatar: "traif.jpg", content: "229 S 4th St Brooklyn, NY 11211", date: Date()),
            LastMessage(friendId: "1", name: "Graham Avenue Meats", avatar: "grahamavenuemeats.jpg", content: "445 Graham Ave Brooklyn, NY 11211", date: Date()),
            LastMessage(friendId: "1", name: "Waffle & Wolf", avatar: "wafflewolf.jpg", content: "413 Graham Ave Brooklyn, NY 11211", date: Date()),
            LastMessage(friendId: "1", name: "Five Leaves", avatar: "fiveleaves.jpg", content: "18 Bedford Ave Brooklyn, NY 11222", date: Date()),
            LastMessage(friendId: "1", name: "Cafe Lore", avatar: "cafelore.jpg", content: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", date: Date()),
            LastMessage(friendId: "1", name: "Confessional", avatar: "confessional.jpg", content: "308 E 6th St New York, NY 10003", date: Date()),
            LastMessage(friendId: "1", name: "Barrafina", avatar: "barrafina.jpg", content: "54 Frith Street London W1D 4SL United Kingdom", date: Date()),
            LastMessage(friendId: "1", name: "Donostia", avatar: "donostia.jpg", content: "10 Seymour Place London W1H 7ND United Kingdom", date: Date()),
            LastMessage(friendId: "1", name: "Royal Oak", avatar: "royaloak.jpg", content: "2 Regency Street London SW1P 4BZ United Kingdom", date: Date()),
            LastMessage(friendId: "1", name: "CASK Pub and Kitchen", avatar: "caskpubkitchen.jpg", content: "22 Charlwood Street London SW1V 2DY Pimlico", date: Date()),
        ]
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
        if segue.identifier == "showChatPage" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! ChatPageTableViewController
                destinationViewController.friend = lastMessages[indexPath.row]
            }
        }
    }

}
