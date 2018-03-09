//
//  ChatPageViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit
import CoreData

class ChatPageTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<UserMO>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyBaordView: UIView!
    @IBOutlet weak var textFeild: UITextField!
    
    var friend = FriendMO()
    var me = UserMO()
    
    var chatMessages: [ChatMessageMO] = []
    
    func getData() {
        
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    me = fetchedObjects[0]
                }
            } catch {
                print(error)
            }
        }
        
        chatMessages = friend.chatMessages?.array as! [ChatMessageMO]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = friend.name

        getData()
        scrollToBottom(animated: false)
        
        // Configure the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(displayP3Red: 237/255, green: 235/255, blue: 235/255, alpha: 1)

        // the keyboard view
        textFeild.delegate = self as UITextFieldDelegate
        textFeild.returnKeyType = UIReturnKeyType.send
        textFeild.enablesReturnKeyAutomatically  = true
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTouches))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chatMessages[indexPath.row].isDateIdentifier == false {
            let cellIdentifier = "ChatMessageCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatMessageCell
            
            cell.friend = friend
            cell.me = me
            cell.message = chatMessages[indexPath.row]
            return cell
        } else {
            let cellIdentifier = "ChatDateIndicatorCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatDateIndicatorCell

            cell.dateLabel.text = chatMessages[indexPath.row].date?.relativeTime
            
            return cell
        }
    }
    
    
    @objc func keyBoardWillShow(note:NSNotification) {
        
        let userInfo  = note.userInfo! as NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            self.keyBaordView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
            self.tableView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    @objc func keyBoardWillHide(note:NSNotification) {
        let userInfo  = note.userInfo! as NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            self.keyBaordView.transform = CGAffineTransform(translationX: 0,y: 0)
            self.tableView.transform = CGAffineTransform(translationX: 0,y: 0)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    @objc func handleTouches(sender:UITapGestureRecognizer){
        if sender.location(in: self.view).y < self.view.bounds.height - 250{
            textFeild.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: use Http to append a message
        
        saveMessageToStoreAndShow()
        textField.text = ""
        scrollToBottom(animated: true)
        
        return false
    }
    
    func saveMessageToStoreAndShow() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // save date indicator if last message is nil or 10 min ago
            if let lastmessageDate = friend.lastMessage?.date {
                if lastmessageDate.timeIntervalSinceNow < -600 {
                    let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                    dateIndicator.date = Date()
                    dateIndicator.contentText = ""
                    dateIndicator.friend = friend
                    dateIndicator.isDateIdentifier = true
                    
                    appDelegate.saveContext()
                    appendMessageAndShow(message: dateIndicator)
                }
            } else {
                let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                dateIndicator.date = Date()
                dateIndicator.contentText = ""
                dateIndicator.friend = friend
                dateIndicator.isDateIdentifier = true
                
                appDelegate.saveContext()
                appendMessageAndShow(message: dateIndicator)
            }
            
            let message = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
            message.isSent = true
            message.date = Date()
            message.contentText = textFeild.text!
            message.friend = friend
            message.isDateIdentifier = false
            
            // delete the old last message and add the new one
            let context = appDelegate.persistentContainer.viewContext
            if friend.lastMessage != nil {
                context.delete(friend.lastMessage!)
            }
            let lastmessage = LastMessageMO(context: appDelegate.persistentContainer.viewContext)
            lastmessage.content = textFeild.text!
            lastmessage.date = Date()
            friend.lastMessage = lastmessage
            
            appDelegate.saveContext()
            appendMessageAndShow(message: message)
        }
    }
    
    func appendMessageAndShow(message: ChatMessageMO) {
        chatMessages.append(message)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: chatMessages.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func scrollToBottom(animated: Bool){
        if self.chatMessages.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    // MARK: - UITableViewDelegate Protocol
    
   /*
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    }
    */
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendManagement" {
            let destinationViewController = segue.destination as! FriendManagementTableViewController
            destinationViewController.friend = friend
        }
    }

}
