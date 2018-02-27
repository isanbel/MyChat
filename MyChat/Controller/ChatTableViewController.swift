//
//  ChatTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
    var chatOutlines: [ChatOutline] = [
        ChatOutline(name: "Cafe Deadend", avatar: "cafedeadend.jpg", chatSlice: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", date: "Coffee & Tea Shop"),
        ChatOutline(name: "Homei", avatar: "homei.jpg", chatSlice: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", date: "Cafe"),
        ChatOutline(name: "Teakha", avatar: "teakha.jpg", chatSlice: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", date: "Tea House"),
        ChatOutline(name: "Cafe loisl", avatar: "cafeloisl.jpg", chatSlice: "Shop B, 20 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", date: "Austrian / Causual Drink"),
        ChatOutline(name: "Petite Oyster", avatar: "petiteoyster.jpg", chatSlice: "24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", date: "French"),
        ChatOutline(name: "For Kee Restaurant", avatar: "forkeerestaurant.jpg", chatSlice: "Shop J-K., 200 Hollywood Road, SOHO, Sheung Wan, Hong Kong", date: "Hong Kong"),
        ChatOutline(name: "Po's Atelier", avatar: "posatelier.jpg", chatSlice: "G/F, 62 Po Hing Fong, Sheung Wan, Hong Kong", date: "Bakery"),
        ChatOutline(name: "Bourke Street Backery", avatar: "bourkestreetbakery.jpg", chatSlice: "633 Bourke St Sydney New South Wales 2010 Surry Hills", date: "Chocolate"),
        ChatOutline(name: "Haigh's Chocolate", avatar: "haighschocolate.jpg", chatSlice: "412-414 George St Sydney New South Wales", date: "Cafe"),
        ChatOutline(name: "Palomino Espresso", avatar: "palominoespresso.jpg", chatSlice: "Shop 1 61 York St Sydney New South Wales", date: "American / Seafood"),
        ChatOutline(name: "Upstate", avatar: "upstate.jpg", chatSlice: "95 1st Ave New York, NY 10003", date: "Seafood"),
        ChatOutline(name: "Traif", avatar: "traif.jpg", chatSlice: "229 S 4th St Brooklyn, NY 11211", date: "American"),
        ChatOutline(name: "Graham Avenue Meats", avatar: "grahamavenuemeats.jpg", chatSlice: "445 Graham Ave Brooklyn, NY 11211", date: "Breakfast & Brunch"),
        ChatOutline(name: "Waffle & Wolf", avatar: "wafflewolf.jpg", chatSlice: "413 Graham Ave Brooklyn, NY 11211", date: "Coffee & Tea"),
        ChatOutline(name: "Five Leaves", avatar: "fiveleaves.jpg", chatSlice: "18 Bedford Ave Brooklyn, NY 11222", date: "Bistro"),
        ChatOutline(name: "Cafe Lore", avatar: "cafelore.jpg", chatSlice: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", date: "Latin American"),
        ChatOutline(name: "Confessional", avatar: "confessional.jpg", chatSlice: "308 E 6th St New York, NY 10003", date: "Spanish"),
        ChatOutline(name: "Barrafina", avatar: "barrafina.jpg", chatSlice: "54 Frith Street London W1D 4SL United Kingdom", date: "Spanish"),
        ChatOutline(name: "Donostia", avatar: "donostia.jpg", chatSlice: "10 Seymour Place London W1H 7ND United Kingdom", date: "Spanish"),
        ChatOutline(name: "Royal Oak", avatar: "royaloak.jpg", chatSlice: "2 Regency Street London SW1P 4BZ United Kingdom", date: "British"),
        ChatOutline(name: "CASK Pub and Kitchen", avatar: "caskpubkitchen.jpg", chatSlice: "22 Charlwood Street London SW1V 2DY Pimlico", date: "Thai"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return chatOutlines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ChatCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = chatOutlines[indexPath.row].name
        cell.chatsliceLabel.text = chatOutlines[indexPath.row].chatSlice
        cell.dateLabel.text = chatOutlines[indexPath.row].date
        cell.thumbnailImageView.image = UIImage(named: chatOutlines[indexPath.row].avatar)

        return cell
    }
    
    // MARK: - UITableViewDelegate Protocol
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.chatOutlines.remove(at: indexPath.row)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
