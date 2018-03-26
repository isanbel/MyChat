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

class ContactCollectionViewController: UICollectionViewController {
    
    var friends: [FriendMO] = []
    
    var isEdite = false
    
    var indexPath: IndexPath?
    var targetIndexPath: IndexPath?
    var saveBtn: UIBarButtonItem?
    
    private lazy var dragingItem: ContactCollectionViewCell = {
        
        let cell = ContactCollectionViewCell(frame: CGRect(x: 50, y: 50, width: imageW + 20, height: imageW + 20))
        cell.isHidden = true
        return cell
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
        saveBtn = UIBarButtonItem(image: UIImage(named: "edit-saved"), style: .plain, target: self, action: #selector(saveChanges))
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = isEdite ? saveBtn : nil
    }
    
    // Mark: get Data
    func loadData() {
        print("== count of friends \(String(describing: Global.user.friends?.count))")
        friends = Global.user.friends?.array as! [FriendMO]
        collectionView?.reloadData()
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
                let newFriend = FriendMO(context: appDelegate.persistentContainer.viewContext)
                newFriend.name = friend["friendname"] as? String
                newFriend.id = friend["friendid"] as? String
                newFriend.attributename = friend["attributename"] as? String
                
                // TODO: parse Date
                // newFriend.birthday
                
                // get avatar
                // TODO: use friendid to get avatar
                let avatarUrl = "http://139.199.174.146:3000/friendAvatar/" + newFriend.id! + ".jpg"
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
            var indexOfItem = 0
            for i in 0..<self.friends.count {
                if self.friends[i].id == cell.id {
                    indexOfItem = i
                }
            }
            self.friends.remove(at: indexOfItem)
            collectionView.deleteItems(at: [IndexPath(item: indexOfItem, section: 0)])
        }
    
        return cell
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
        self.viewDidAppear(true)
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
    
    @objc func saveChanges() {
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

