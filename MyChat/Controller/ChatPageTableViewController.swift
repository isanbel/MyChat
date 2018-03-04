//
//  ChatPageViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class ChatPageTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyBaordView: UIView!
    @IBOutlet weak var textFeild: UITextField!
    
    var friend = ChatOutline()
    var me = User()
    
    var chatMessages: [ChatMessage] = []
    
    func getData() {
        // clearData()
        chatMessages = [
            ChatMessage(isDateIndicator: true),
            ChatMessage(msgType: MsgType.Sent, contentText: "今天遇见了那年的老朋友，一时间竟叫不出名字"),
            ChatMessage(msgType: MsgType.Sent, contentText: "Mary，你还记得那年的女孩吗？"),
            ChatMessage(msgType: MsgType.Received, contentText: "好呀"),
            ChatMessage(isDateIndicator: true),
            ChatMessage(msgType: MsgType.Sent, contentText: "今天傍晚，雷雨中传来一阵丁香花的香味"),
            ChatMessage(msgType: MsgType.Received, contentText: "我想起了故乡的山楂花树篱"),
            ChatMessage(msgType: MsgType.Received, contentText: "你好呀"),
            ChatMessage(isDateIndicator: true),
            ChatMessage(msgType: MsgType.Sent, contentText: "今天遇见了那年的老朋友，一时间竟叫不出名字"),
            ChatMessage(msgType: MsgType.Sent, contentText: "Mary，你还记得那年的女孩吗？"),
            ChatMessage(msgType: MsgType.Received, contentText: "好呀"),
            ChatMessage(isDateIndicator: true),
            ChatMessage(msgType: MsgType.Sent, contentText: "今天傍晚，雷雨中传来一阵丁香花的香味"),
            ChatMessage(msgType: MsgType.Received, contentText: "我想起了故乡的山楂花树篱")
        ]
        
        me = User(userId: "123", name: "palominoespresso", gender: "male", birthday: Date(), avatar: "palominoespresso", email: "12@asd.com", password: "luanMa")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = friend.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .done, target: self, action: #selector(addTapped))

        getData()
        scrollToBottom(animated: false)
        
        // Configure the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

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
    
    @objc func addTapped() {
        print("haha")
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
        
        if chatMessages[indexPath.row].isDateIndicator == false {
            let cellIdentifier = "ChatMessageCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatMessageCell
            
            cell.friend = friend
            cell.me = me
            cell.message = chatMessages[indexPath.row]
            return cell
        } else {
            let cellIdentifier = "ChatDateIndicatorCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatDateIndicatorCell

            cell.dateLabel.text = chatMessages[indexPath.row].date.relativeTime
            
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
        self.view.endEditing(true)
        // textField.resignFirstResponder()
        
        // append message
        chatMessages.append(ChatMessage(msgType: MsgType.Sent, contentText: textFeild.text!))
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: chatMessages.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        scrollToBottom(animated: true)
        
        textFeild.text = ""
        
        return false
    }
    
    func scrollToBottom(animated: Bool){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
