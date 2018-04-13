//
//  ContactCollectionViewController.swift
//  MyChatContactDemo
//
//  Created by Yuanyuan Zhang on 15/03/2018.
//  Copyright © 2018 Isanbel. All rights reserved.
//

import UIKit

private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height

private let reuseIdentifier = "ContactViewCell"

class ContactCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    var friends: [FriendMO] = []
    
    var isEdite = false
    
    var indexPath: IndexPath?
    var targetIndexPath: IndexPath?
    
    // @IBOutlet weak var loading: UIActivityIndicatorView!
    var activityIndicator: UIActivityIndicatorView!
    
    private lazy var dragingItem: ContactCollectionViewCell = {
        
        let cell = ContactCollectionViewCell(frame: CGRect(x: 50, y: 50, width: imageW + 20, height: imageW + 20))
        cell.isHidden = true
        return cell
    }()
    
    private lazy var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y: SCREEN_WIDTH / 2, width: SCREEN_WIDTH, height: 50)
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#777777")
        label.text = "努力帮你寻找好友中...么么哒"
        loadingView.addSubview(label)
        loadingView.layer.zPosition = 2
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
        
        self.collectionView?.collectionViewLayout = ContactViewLayout()
        self.collectionView?.addSubview(dragingItem)
        dragingItem.layer.zPosition = 1
        
        collectionView?.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let longPress = UILongPressGestureRecognizer()
        longPress.addTarget(self, action: #selector(longPressGesture))
        collectionView?.addGestureRecognizer(longPress)
        
        // tap the blank place, then save the icons arrangetment changes
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self as UIGestureRecognizerDelegate
        self.collectionView?.backgroundView = UIView(frame:(self.collectionView?.bounds)!)
        self.collectionView?.backgroundView!.addGestureRecognizer(tapGestureRecognizer)
        
        // loading
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    // Mark: get Data
    func loadData() {
        print("== count of friends \(String(describing: Global.user.friends?.count))")
        friends = Global.user.friends?.array as! [FriendMO]
        collectionView?.reloadData()
        if (friends.count == 0) {
            self.view.addSubview(loadingView)
            activityIndicator.startAnimating()
        }
    }
    
    func getFriends() {
        let url: String = "/friends?userid=" + Global.user.id!
        let onSuccess = { (data: [String: Any]) in
            print("== getFriends success")
            self.storeNewFriends(data: data)
            self.loadData()
            if (self.activityIndicator.isAnimating) {
                self.loadingView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            }
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
                let newFriend = FriendMO(context: appDelegate.persistentContainer.viewContext)
                newFriend.name = friend["friendname"] as? String
                newFriend.id = friend["friendid"] as? String
                newFriend.attributename = friend["attributename"] as? String
                
                // TODO: parse Date
                // newFriend.birthday
                
                // get avatar
                // TODO: use friendid to get avatar
                let avatarUrl = "http://\(Config.SERVER_IP):3000/friendAvatar/" + newFriend.id! + ".jpg"
                let url = URL(string: avatarUrl)
                let avatar = try? Data(contentsOf: url!)
                newFriend.avatar = avatar
                
                newFriend.isMale = friend["friendid"] as? String == "male" ? true : false
                
                newFriend.user = Global.user
                
                appDelegate.saveContext()
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactCollectionViewCell
        
        if let avatarImage = friends[indexPath.row].avatar {
            cell.image = UIImage(data: avatarImage as Data)!
        }
        cell.id = friends[indexPath.item].id!
        cell.name = friends[indexPath.item].name!
        cell.isEditing = self.isEdite
        cell.remove = {
            // 弹窗确认删除
            let alert = UIAlertController(title:"温馨提示",message:"确认要删除" + cell.name + "吗？",preferredStyle:.alert)
            let cancel=UIAlertAction(title:"取消",style:.cancel)
            let confirm=UIAlertAction(title:"确定",style:.default){(action)in
                self.removeCell(atCellId: cell.id)
                self.removeFriend(atFriendId: cell.id)
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
        }
    
        return cell
    }
    
    func removeCell(atCellId: String) {
        var indexOfItem = 0
        for i in 0..<self.friends.count {
            if self.friends[i].id == atCellId {
                indexOfItem = i
            }
        }
        // delete the friend in the store
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.friends[indexOfItem])
            appDelegate.saveContext()
        }
        self.friends.remove(at: indexOfItem)
        
        collectionView?.deleteItems(at: [IndexPath(item: indexOfItem, section: 0)])
    }
    
    func removeFriend(atFriendId: String) {
        let userid = Global.user.id
        let friendId = atFriendId
        
        let parameters: [String: Any] = [
            "userid": userid!,
            "friendid": friendId
        ]
        
        let url = "/friends"
        let onSuccess = { (data: [String: Any]) in
        }
        let onFailure = { (data: [String: Any]) in
            let msg = data["message"] as! String
            self.present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
        }
        
        HttpUtil.delete(url: url, parameters: parameters, onSuccess: onSuccess, onFailure: onFailure);
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "contactToChatPage", sender: self)
    }
    
    @objc func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        if !isEdite {
            isEdite = !isEdite
            collectionView?.reloadData()
            return
        }
        let point = tap.location(in: collectionView)
        
        switch tap.state {
            case UIGestureRecognizerState.began:
                dragBegan(point: point)
            case UIGestureRecognizerState.changed:
                drageChanged(point: point)
            case UIGestureRecognizerState.ended:
                drageEnded(point: point)
            case UIGestureRecognizerState.cancelled:
                drageEnded(point: point)
            default: break
        }
    }
    
    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        indexPath = collectionView?.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 {return}
        
        let item = collectionView?.cellForItem(at: indexPath!) as? ContactCollectionViewCell
        item?.isHidden = true
        
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.image = (item?.image)!
        dragingItem.name = (item?.name)!
        dragingItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }

    //MARK: - 长按过程
    private func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 {return}
        dragingItem.center = point
        targetIndexPath = collectionView?.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || indexPath == targetIndexPath {return}
        // 更新数据
        let obj = friends[indexPath!.item]
        friends.remove(at: indexPath!.row)
        friends.insert(obj, at: targetIndexPath!.item)
        //交换位置
        collectionView?.moveItem(at: indexPath!, to: targetIndexPath!)
        indexPath = targetIndexPath
    }
    
    //MARK: - 长按结束
    private func drageEnded(point: CGPoint) {
        
        if indexPath == nil || (indexPath?.section)! > 0 {return}
        let endCell = collectionView?.cellForItem(at: indexPath!)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.dragingItem.transform = CGAffineTransform.identity
            self.dragingItem.center = (endCell?.center)!
            
        }, completion: {
            (finish) -> () in
            
            endCell?.isHidden = false
            self.dragingItem.isHidden = true
            self.indexPath = nil
        })
    }
    
    @objc func handleTap() {
        saveChanges()
    }
    
    func saveChanges() {
        isEdite = false
        self.viewDidAppear(true)
        collectionView?.reloadData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactToChatPage" {
            if let indexPath = collectionView?.indexPathsForSelectedItems![0] {
                let destinationViewController = segue.destination as! ChatPageTableViewController
                destinationViewController.friend = friends[indexPath.item]
            }
        }
    }
}

//MARK: - 自定义布局属性
class ContactViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: imageW + 20, height: imageW + 10 + 20)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        let paddingLeft = (SCREEN_WIDTH - 4 * (imageW + 20) - 10 * 2) / 5 + 10
        sectionInset = UIEdgeInsets(top: 10, left: paddingLeft, bottom: 10, right: paddingLeft)
    }
}
