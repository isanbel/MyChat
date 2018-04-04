//
//  EntryViewController.swift
//  MyChat
//
//  Created by painterdrown on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit
import CoreData

class EntryViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    var fetchResultController: NSFetchedResultsController<UserMO>!
    var isToLogin = true
    var correctCode: String?
    
    var codeTimer: Timer?
    var remainingSec: Int = 60

    @IBOutlet weak var username_tf: UITextField! {
        didSet {
            username_tf.defaultTextAttributes = [NSAttributedStringKey.font.rawValue : UIFont(name: "PingFangSC-Regular", size: 14)!, NSAttributedStringKey.foregroundColor.rawValue : UIColor(hex: "#4c72a6")]
            
            username_tf.placeholder = "手机号码"
            username_tf.borderStyle = .none
        }
    }
    
    @IBOutlet weak var code_tf: UITextField! {
        didSet {
            code_tf.defaultTextAttributes = [NSAttributedStringKey.font.rawValue : UIFont(name: "PingFangSC-Regular", size: 14)!, NSAttributedStringKey.foregroundColor.rawValue : UIColor(hex: "#4c72a6")]
            
            code_tf.placeholder = "验证码"
            code_tf.borderStyle = .none
        }
    }
    
    @IBAction func getCode(_ sender: UIButton) {
        let username = username_tf.text!
        
        if !isValidEmail(testStr: username) {
            let msg = "请输入有效的邮箱"
            present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
        }
        
        let parameters: [String: Any] = [
            "username": username
        ]

        let url: String = "/users/auth"
        let that = self
        let onSuccess = { (data: [String: Any]) in
            self.remainingSec = 120
            self.codeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startCodeTimer), userInfo: nil, repeats: true)
            self.correctCode = data["authcode"] as? String
        }
        let onFailure = { (data: [String: Any]) in
            let msg = data["message"] as! String
            that.present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
        }
        
        HttpUtil.post(url: url, parameters: parameters, onSuccess: onSuccess, onFailure: onFailure);
    }
    
    @objc func startCodeTimer()
    {
        getCodeBtn.setTitle(String(remainingSec) + "s", for: .normal)
        getCodeBtn.isEnabled = false
        remainingSec = remainingSec - 1
        if remainingSec < 0 {
            stopCodeTimer()
        }
    }
    
    func stopCodeTimer() {
        getCodeBtn.setTitle("发送验证码", for: .normal)
        getCodeBtn.isEnabled = true
        correctCode = nil
        if codeTimer != nil {
            codeTimer?.invalidate()
            codeTimer = nil
        }
    }
    
    @IBOutlet weak var codeAreaView: UIStackView! {
        didSet {
            codeAreaView.isHidden = true
        }
    }
    
    @IBOutlet weak var password_tf: UITextField! {
        didSet {
            password_tf.defaultTextAttributes = [NSAttributedStringKey.font.rawValue : UIFont(name: "PingFangSC-Regular", size: 14)!, NSAttributedStringKey.foregroundColor.rawValue : UIColor(hex: "#4c72a6")]
            
            password_tf.placeholder = "密码"
            password_tf.borderStyle = .none
        }
    }
    
    @IBOutlet weak var selectView: UISegmentedControl! {
        didSet {
            let frame = selectView.frame
            selectView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: 150, height: 35)
            selectView.layer.cornerRadius = 17.5
            selectView.layer.masksToBounds = true
            selectView.layer.borderColor = UIColor(hex: "#edf2fa").cgColor
            selectView.layer.borderWidth = 1
            
            selectView.layer.backgroundColor = UIColor.white.cgColor
            selectView.tintColor = UIColor(hex: "#edf2fa")
            
            selectView.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "PingFangSC-Medium", size: 14)!, NSAttributedStringKey.foregroundColor : UIColor(hex: "#4c72a6")], for: .selected)
            selectView.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "PingFangSC-Regular", size: 14)!, NSAttributedStringKey.foregroundColor : UIColor(hex: "#9fa0a0")], for: .normal)
        }
    }
    
    @IBOutlet var textAreas: [UIView]! {
        didSet {
            for textArea in textAreas {
                let frame = textArea.frame
                textArea.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 50)
                textArea.layer.cornerRadius = 25
                textArea.layer.masksToBounds = true
                textArea.layer.borderColor = UIColor(hex: "#d7e0ed").cgColor
                textArea.layer.backgroundColor = UIColor.white.cgColor
                textArea.layer.borderWidth = 1
            }
        }
    }
    
    @IBOutlet weak var forgetPwView: UIStackView!
    @IBOutlet weak var entryBtn: UIButton!
    @IBOutlet weak var getCodeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password_tf.isSecureTextEntry = true
        
        selectView.setTitle("登录", forSegmentAt: 0)
        selectView.setTitle("注册", forSegmentAt: 1)
        selectView.addTarget(self, action: #selector(tabSegment), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func codeIsCorrect() -> Bool {
        let code = code_tf.text!
        if code == correctCode {
            return true
        } else {
            let msg = "验证码错误"
            present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
            return false
        }
    }
    
    @IBAction func entry_bt(_ sender: UIButton) {
        let username = username_tf.text!
        let password = password_tf.text!
        
        // 检查账号密码不为空
        if (!isValidEmail(testStr: username)) {
            let msg = "请输入有效的邮箱"
            present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
            return
        }
        if (password.isEmpty) {
            let msg = "密码不能为空"
            present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
            return
        }
        
        // 如果是注册，先验证验证码
        if !isToLogin && !codeIsCorrect() {
            return
        }
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        let url: String = isToLogin ? "/users/signin" : "/users/signup"
        let that = self
        let onSuccess = { (data: [String: Any]) in
            self.self.saveUserData(data: data)
            that.performSegue(withIdentifier: "Enter", sender: nil)
        }
        
        let onFailure = { (data: [String: Any]) in
            let msg = data["message"] as! String
            that.present(Utils.getAlertController(title: "错误", message: msg), animated: true, completion: nil)
        }
        
        HttpUtil.post(url: url, parameters: parameters, onSuccess: onSuccess, onFailure: onFailure);
    }
    
    func saveUserData(data: [String: Any]) {
        if checkIfUserExist(data: data) == true {
            return
        }
        // else save new user
        print("== user data not exists in the store")
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
            
            user.loggedin = true
            
            appDelegate.saveContext()
            
            // Save to Global also
            Global.user = user
        }
    }
    
    func checkIfUserExist(data: [String: Any]) -> Bool {
        let userId = data["userid"] as? String
        
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self as? NSFetchedResultsControllerDelegate
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    
                    // if this user exists
                    for i in 0..<fetchedObjects.count {
                        if fetchedObjects[i].id == userId {
                            print("== user exists")
                            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                            
                                fetchedObjects[i].loggedin = true
                                
                                appDelegate.saveContext()
                                
                                // Save to Global also
                                Global.user = fetchedObjects[i]
                            }
                            return true
                        }
                    }
                    return false
                }
            } catch {
                print(error)
                return false
            }
        }
        return false
    }
    
    @objc func tabSegment() {
        let toLogin = selectView.selectedSegmentIndex == 0
        isToLogin = toLogin
        codeAreaView.isHidden = toLogin ? true : false
        password_tf.placeholder = toLogin ? "密码" : "密码（不超过12位）"
        forgetPwView.isHidden = toLogin ? false : true
        let entryBtnTitle = toLogin ? "登  录" : "注  册"
        entryBtn.setTitle(entryBtnTitle, for: .normal)
        for constraint in view.constraints {
            if constraint.identifier == "entryBtnToForgetPwC" {
                constraint.constant = toLogin ? 30 : 5
            }
        }
        view.layoutIfNeeded()
    }
    
    // Mark - KeyBoard
    @objc func keyBoardWillShow(note:NSNotification) {
        
        let userInfo  = note.userInfo! as NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            self.view.transform = CGAffineTransform(translationX: 0,y: -50)
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
            self.view.transform = CGAffineTransform(translationX: 0,y: 0)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    

}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
