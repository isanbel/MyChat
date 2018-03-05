//
//  ChatTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit
import CoreData

class ChatTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var lastMessages: [LastMessageMO] = []
    var fetchResultController: NSFetchedResultsController<LastMessageMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

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

//        cell.nameLabel.text = lastMessages[indexPath.row].name
        cell.chatsliceLabel.text = lastMessages[indexPath.row].content
        cell.dateLabel.text = lastMessages[indexPath.row].date?.relativeTime
//        if let avatar = lastMessages[indexPath.row].avatar {
//            cell.thumbnailImageView.image = UIImage(data: avatar as Data)
//        }
        // cell.thumbnailImageView.image = UIImage(named: lastMessages[indexPath.row].avatar)

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
        
        // Save data
//        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//            let lastMessage = LastMessageMO(context: appDelegate.persistentContainer.viewContext)
//            lastMessage.stickOnTop = false
//            lastMessage.friendId = "123"
//            lastMessage.content = "haha"
//            lastMessage.date = Date()
//
//            appDelegate.saveContext()
//        }
//
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<LastMessageMO> = LastMessageMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    lastMessages = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
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
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "showChatPage" {
    //            if let indexPath = tableView.indexPathForSelectedRow {
    //                let destinationViewController = segue.destination as! ChatPageTableViewController
    //                destinationViewController.friend = lastMessages[indexPath.row]
    //            }
    //        }
    //    }

}
