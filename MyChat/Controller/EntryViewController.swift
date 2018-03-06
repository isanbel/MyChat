//
//  EntryViewController.swift
//  MyChat
//
//  Created by Raincome on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit
import Alamofire

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func entry_bt(_ sender: UIButton) {
        Alamofire.request("http://127.0.0.1:3003/").response { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
        }
        // performSegue(withIdentifier: "Enter", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
