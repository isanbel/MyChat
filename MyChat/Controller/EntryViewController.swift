//
//  EntryViewController.swift
//  MyChat
//
//  Created by painterdrown on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func entry_bt(_ sender: UIButton) {
        let username = username_tf.text!
        let password = password_tf.text!
        
        // 检查账号密码不为空
        if (username.isEmpty) {
            let msg = "账号不能为空"
            present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
            return
        }
        if (password.isEmpty) {
            let msg = "密码不能为空"
            present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
            return
        }
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        let url: String = "/users/signin"
        let that = self
        let onSuccess = { (data: [String: Any]) in
            self.self.saveUserData(data: data)
            that.performSegue(withIdentifier: "Enter", sender: nil)
        }
        
        let onSignupFailure = { (data: [String: Any]) in
            let msg = "用户名不存在，尝试创建新用户失败"
            that.present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
        }
        let onSigninFailure = { (data: [String: Any]) in
            let msg = data["message"] as! String
            if (msg == "用户名不存在") {
                let url = "/users/signup"
                HttpUtil.post(url: url, parameters: parameters, onSuccess: onSuccess, onFailure: onSignupFailure)
            } else {
                that.present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
            }
        }
        HttpUtil.post(url: url, parameters: parameters, onSuccess: onSuccess, onFailure: onSigninFailure);
    }
    
    func saveUserData(data: [String: Any]) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let user = UserMO(context: appDelegate.persistentContainer.viewContext)
            user.name = data["username"] as? String
            user.email = ""
            user.password = data["password"] as? String
            user.isMale = true
            user.id = data["userid"] as? String
            user.birthday = Date()
            
            let avatarUrl = "http://139.199.174.146:3000/avatar/" + user.id! + ".jpg"
            let url = URL(string: avatarUrl)
            let avatar = try? Data(contentsOf: url!)
            user.avatar = avatar
            
            appDelegate.saveContext()
            
            // Save to Global also
            Global.user = user
        }
    }
}
