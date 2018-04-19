//
//  NewFriendTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 05/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit
import CoreData

class NewFriendTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var selectView: UISegmentedControl! {
        didSet {
            selectView.layer.cornerRadius = 5
            selectView.layer.masksToBounds = true
            // selectView.layer.borderColor = UIColor(hex: "#edf2fa").cgColor
            selectView.layer.borderWidth = 0
            
            selectView.layer.backgroundColor = UIColor.white.cgColor
            selectView.tintColor = UIColor(hex: "#edf2fa")
            
            selectView.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "PingFangSC-Medium", size: 14)!, NSAttributedStringKey.foregroundColor : UIColor(hex: "#4c72a6")], for: .selected)
            selectView.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "PingFangSC-Regular", size: 14)!, NSAttributedStringKey.foregroundColor : UIColor(hex: "#9fa0a0")], for: .normal)
        }
    }
    
    @IBOutlet var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the table view
        tableView.tableFooterView = UIView()
        
        // default avatar
        photoImageView.image = UIImage(named: "avatar")
        selectView.setTitle("男", forSegmentAt: 0)
        selectView.setTitle("女", forSegmentAt: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "拍摄", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "照片", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .default, handler: { (action) in
                
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            present(photoSourceRequestController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Action method
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if !validateInputs() { return }
        
        addFriend() // -> updateAvatar() -> saveFriendData() -> popView
    }
    
    func addFriend() {
        let userid = Global.user.id
        let friendName = nameTextField.text
        let friendGender = selectView.selectedSegmentIndex == 0 ? "male" : "female"
        
        let parameters: [String: Any] = [
            "userid": userid!,
            "friendname": friendName!,
            "gender": friendGender,
            "birth": Date().description
        ]
        
        let url = "/friends"
        let onSuccess = { (data: [String: Any]) in
            self.updateAvatar(data: data)
        }
        let onFailure = { (data: [String: Any]) in
            let msg = data["message"] as! String
            self.present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
        }
        
        HttpUtil.post(url: url, parameters: parameters, onSuccess: onSuccess, onFailure: onFailure);
    }
    
    func updateAvatar(data: [String: Any]) {
        let friendId = data["friendid"]
        
        let parameters: [String: Any] = [
            "friendid": friendId!
        ]
        
        let url = "/friends/upload"
        let thatData = data
        let onSuccess = { (data: [String: Any]) in
            self.saveFriendData(data: thatData)
        }
        let onFailure = { (data: [String: Any]) in
            let msg = data["message"] as! String
            self.present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
            
            // still save since the friend was really created
            self.saveFriendData(data: thatData)
        }
        
        HttpUtil.postWithImage_(url: url, imageName: "friendAvatar", image: photoImageView.image!, parameters: parameters, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func saveFriendData(data: [String: Any]) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let friend = FriendMO(context: appDelegate.persistentContainer.viewContext)
            friend.name = data["friendname"] as? String
            friend.isMale = (data["gender"] as? String == "male") ? true : false
            friend.id = data["friendid"] as? String
            friend.birthday = Date()
            if let friendAvatar = photoImageView.image {
                friend.avatar = UIImagePNGRepresentation(friendAvatar)
            }
            friend.user = Global.user
            
            appDelegate.saveContext()
        }
        // pop to last page view
        navigationController?.popViewController(animated: true)
    }
    
    func validateInputs() -> Bool {
        if let friendAvatar = photoImageView.image {
            if friendAvatar == UIImage(named: "avatar") {
                alertMessage(controllerTitle: "添加失败", message: "请为好友设置头像", actionTitle: "好的")
                return false
            }
        }
        if nameTextField.text == "" {
            alertMessage(controllerTitle: "添加失败", message: "请为好友想个名字", actionTitle: "好的")
            return false
        }
        
        return true
    }
    
    func alertMessage(controllerTitle: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: controllerTitle, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}
