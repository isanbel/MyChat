//
//  MyProfileTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 06/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class MyProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mychatidLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    
    var user = UserMO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(displayP3Red: 237/255, green: 235/255, blue: 235/255, alpha: 1)
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
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    func loadData() {
        
        user = Global.user
        
        nameLabel.text = user.name
        mychatidLabel.text = user.id
        if let avatarImage = user.avatar {
            avatarImageView.image = UIImage(data: avatarImage as Data)
        }
        
    }
    
    @IBAction func changeAvatar(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "更换头像", message: nil, preferredStyle: .actionSheet)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let takePhotos = UIAlertAction(title: "拍照", style: .destructive, handler: {
            (action: UIAlertAction) -> Void in
            // 判断是否能进行拍照，可以的话打开相机
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            } else {
                print("模拟器中无法打开照相机, 请在真机中使用");
            }
        })
        let selectPhotos = UIAlertAction(title: "相册", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            // 调用相册功能，打开相册
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        print(type)
    }
}
