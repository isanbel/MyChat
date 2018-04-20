//
//  ChatPageViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 27/02/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import SwiftyJSON
import SocketIO

enum InputTool {
    case keyboard
    case microphone
}

class ChatPageTableViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate,
    NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyBaordView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var inputToolBtn: UIButton!
    
    // iFly
    var iflySpeechRecognizer: IFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance() as IFlySpeechRecognizer
    var is_recording: Bool = false
    var voice_message: String = ""
    
    var fetchResultController: NSFetchedResultsController<UserMO>!
    var friend = FriendMO()
    var me = UserMO()
    var chatMessages: [ChatMessageMO] = []
    var hiddenTableCellHeight: CGFloat = 0
    var keyBoardHeight: CGFloat = 0
    var translationY: CGFloat = 0

    var keyBoardOnRight: Bool = true
    var keyBoardSnapShotView: UIImageView!
    
    var inputTool: InputTool = InputTool.keyboard
    var inputTextBeforeUsingMicrophone: String?
    let recordingBtn = UIButton()
    
    // socket
    var socket_manager: SocketManager!
    var socket: SocketIOClient!
    
    private lazy var recordingView: UIView = {
        let recordingView = UIView()
        recordingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        recordingView.center = self.view.center
        recordingView.frame.origin.y  = recordingView.frame.origin.y - 100
        recordingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        recordingView.layer.cornerRadius = 10
        recordingView.layer.masksToBounds = true
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "录音中"
        recordingView.addSubview(label)
        recordingView.layer.zPosition = 2
        
        return recordingView
    }()
    
    func initRecordingBtn() {
        recordingBtn.addTarget(self, action: #selector(startRecord), for: .touchDown)
        recordingBtn.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
    }
    
    @objc func startRecord() {
        activeRecordingBtn()
        self.view.addSubview(recordingView)
        
        self.iflySpeechRecognizer.startListening()
        self.is_recording = true
        print("startRecord")
    }
    
    @objc func stopRecord() {
        releaseRecordingBtn()
        recordingView.removeFromSuperview()
        
        self.iflySpeechRecognizer.stopListening()
        self.is_recording = false
        print("stopRecord")
    }
    
    func activeRecordingBtn() {
        textField.text = "松开 结束"
        textField.backgroundColor = keyBoardOnRight ? UIColor(hex: "#dddddd") : UIColor(hex: "#bbbbbb")
    }
    
    func releaseRecordingBtn() {
        textField.text = "按住 说话"
        textField.backgroundColor = keyBoardOnRight ? .white : UIColor(hex: "#f1f1f1")
    }
    
    @IBAction func switchInputTool() {
        inputTool = inputTool == InputTool.keyboard ? InputTool.microphone : InputTool.keyboard
        
        // 使用麦克风
        if inputTool == InputTool.microphone {
            // 更新输入框
            inputTextBeforeUsingMicrophone = textField.text
            textField.text = "按住 说话"
            textField.font = UIFont(name: (textField.font?.fontName)!, size: 18)
            textField.textAlignment = .center
            
            // 收起键盘
            textField.resignFirstResponder()
            
            addRecordingBtn()
        }
        // 使用键盘
        else {
            // 更新输入框
            textField.text = inputTextBeforeUsingMicrophone
            inputTextBeforeUsingMicrophone = nil
            textField.font = UIFont(name: (textField.font?.fontName)!, size: 14)
            textField.textAlignment = .left
            
            // 打开键盘
            textField.becomeFirstResponder()
            
            removeRecordingBtn()
        }
        
        // 更新图标
        let btnIconName = inputTool == InputTool.keyboard ? "chat-input-voice" : "chat-input-keyboard"
        inputToolBtn.setImage(UIImage(named: btnIconName), for: .normal)
    }
    
    func addRecordingBtn() {
        recordingBtn.frame = textField.frame
        recordingBtn.frame.origin.y = recordingBtn.frame.origin.y + keyBaordView.frame.origin.y
        self.view.addSubview(recordingBtn)
    }
    
    func removeRecordingBtn() {
        recordingBtn.removeFromSuperview()
    }
    
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
        self.navigationController?.navigationItem.backBarButtonItem?.title = friend.name

        getData()
        scrollToBottom(animated: false)

        // Configure the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white

        // the keyboard view
        textField.delegate = self as UITextFieldDelegate
        textField.returnKeyType = UIReturnKeyType.send
        textField.enablesReturnKeyAutomatically  = true
        initRecordingBtn()

         NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTouches))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        initIfly()
        
        addGestureToKeyBoardView()

        print(friend)
        initSocket()
        
        readUnreadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("我来到了：ChatPageTableViewController")
        setDelegate()
        updateLeftTopNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
            cell.lastMessage = indexPath.row > 1 ? chatMessages[indexPath.row - 1] : nil
            cell.message = chatMessages[indexPath.row]
            cell.showProfile = { () in
                self.performSegue(withIdentifier: "ShowFriendProfile", sender: self)
            }
            
            return cell
        } else {
            let cellIdentifier = "ChatDateIndicatorCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatDateIndicatorCell

            cell.dateLabel.text = chatMessages[indexPath.row].date?.relativeDetailedTime

            return cell
        }
    }


    @objc func keyBoardWillShow(note:NSNotification) {
        let userInfo  = note.userInfo! as NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        keyBoardHeight = keyBoardBounds.size.height

        let animations:(() -> Void) = {
            self.keyBaordView.transform = CGAffineTransform(translationX: 0,y: -deltaY)

            let tableViewContentToBottom = self.tableView.bounds.size.height - self.tableView.contentSize.height
            if tableViewContentToBottom > deltaY {
                self.translationY = 0
            } else if tableViewContentToBottom <= 0 {
                self.translationY = -deltaY
            } else {
                self.translationY = tableViewContentToBottom - deltaY
            }
            self.tableView.transform = CGAffineTransform(translationX: 0,y: self.translationY)
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
            textField.resignFirstResponder()
        }
    }

    func pushTableViewIfHidden() {
        let tableViewContentToBottom = self.tableView.bounds.size.height - self.tableView.contentSize.height
        if tableViewContentToBottom < keyBoardHeight && -keyBoardHeight < translationY {
            if tableViewContentToBottom > hiddenTableCellHeight {
                translationY -= hiddenTableCellHeight
            } else if tableViewContentToBottom > 0 {
                translationY -= tableViewContentToBottom
            } else {
                translationY = -keyBoardHeight
            }
        }
        self.tableView.transform = CGAffineTransform(translationX: 0,y: translationY)
        hiddenTableCellHeight = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveMessageToStoreAndShow()
        textField.text = ""
        scrollToBottom(animated: true)
        return false
    }
    
    func appendDateIndicatorIfNeeded() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // save date indicator if last message is nil or 5 min ago
            if let lastmessageDate = friend.lastMessage?.date {
                if lastmessageDate.timeIntervalSinceNow < -300 {
                    let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                    dateIndicator.date = Date()
                    dateIndicator.contentText = ""
                    dateIndicator.friend = friend
                    dateIndicator.isDateIdentifier = true
                    appendMessageAndShow(message: dateIndicator)
                }
            } else {
                let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                dateIndicator.date = Date()
                dateIndicator.contentText = ""
                dateIndicator.friend = friend
                dateIndicator.isDateIdentifier = true
                appendMessageAndShow(message: dateIndicator)
            }
            appDelegate.saveContext()
        }
    }
    
    func sendMessage(_ message_sent: String) {
        let msgTypeIsSent = keyBoardOnRight
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appendDateIndicatorIfNeeded()
            
            let message = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
            message.isSent = msgTypeIsSent
            message.date = Date()
            message.contentText = message_sent
            message.friend = friend
            message.isDateIdentifier = false
            
            // delete the old last message and add the new one
            let context = appDelegate.persistentContainer.viewContext
            if friend.lastMessage != nil {
                context.delete(friend.lastMessage!)
            }
            
            // 更新 lastMessage
            let lastmessage = LastMessageMO(context: appDelegate.persistentContainer.viewContext)
            lastmessage.content = message_sent
            lastmessage.date = Date()
            friend.lastMessage = lastmessage
            
            // 保存发送的信息
            appDelegate.saveContext()
            appendMessageAndShow(message: message)
            
            if msgTypeIsSent {
                socketSend(message: message_sent)
            }
        }
    }

    func saveMessageToStoreAndShow() {
        let messgae = textField.text!
        sendMessage(messgae)
    }
    
    func appendMessageAndShow(message: ChatMessageMO) {
        chatMessages.append(message)

        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: chatMessages.count - 1, section: 0)], with: .bottom)
        tableView.endUpdates()

        // deal with the hidden cell by the keyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: IndexPath(row: chatMessages.count - 1, section: 0))
        hiddenTableCellHeight = cell.bounds.height
        // Add bubble bottom constraint length. it seems the bounds.height doesnot count it
        hiddenTableCellHeight += 12
        pushTableViewIfHidden()

        scrollToBottom(animated: true)
        
        // 解决tableview自己往上跑的问题
        if inputTool == InputTool.microphone {
            self.tableView.transform = CGAffineTransform(translationX: 0,y: 0)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        if self.chatMessages.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    // TODO: 改成 friendSendsMessages 比较好，支持发多条信息
    func friendSendsMessage(_ message_sent: String) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            // save date indicator if last message is nil or 5 min ago
            if let lastmessageDate = friend.lastMessage?.date {
                if lastmessageDate.timeIntervalSinceNow < -300 {
                    let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                    dateIndicator.date = Date()
                    dateIndicator.contentText = ""
                    dateIndicator.friend = friend
                    dateIndicator.isDateIdentifier = true
                    appendMessageAndShow(message: dateIndicator)
                }
            } else {
                let dateIndicator = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
                dateIndicator.date = Date()
                dateIndicator.contentText = ""
                dateIndicator.friend = friend
                dateIndicator.isDateIdentifier = true
                appendMessageAndShow(message: dateIndicator)
            }
            
            let message = ChatMessageMO(context: appDelegate.persistentContainer.viewContext)
            message.isSent = false
            message.date = Date()
            message.contentText = message_sent
            message.friend = friend
            message.isDateIdentifier = false
            
            // delete the old last message and add the new one
            let context = appDelegate.persistentContainer.viewContext
            if friend.lastMessage != nil {
                context.delete(friend.lastMessage!)
            }
            
            // 更新 lastMessage
            let lastmessage = LastMessageMO(context: appDelegate.persistentContainer.viewContext)
            lastmessage.content = message_sent
            lastmessage.date = Date()
            friend.lastMessage = lastmessage
            
            // 保存发送的信息
            appDelegate.saveContext()
            appendMessageAndShow(message: message)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendManagement" {
            let destinationViewController = segue.destination as! FriendManagementTableViewController
            destinationViewController.friend = friend
        }
        
        if segue.identifier == "ShowFriendProfile" {
            let destinationViewController = segue.destination as! FriendProlileTableViewController
            destinationViewController.friend = self.friend
        }
    }

}
