//
//  File.swift
//  MyChat
//
//  Created by painterdrown on 07/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HttpUtil {
    static let BASE_URL: String = "http://139.199.174.146:3000/api"
    
    static func post(url: String, parameters: Parameters, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping([String: Any]) -> Void) {
        Alamofire.request(BASE_URL + url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                let value = response.result.value!
                let json = JSON(value)
                print(json)
                if let code = json["code"].int, code == 0 {
                    onSuccess(json.dictionaryObject!)
                } else {
                    onFailure(json.dictionaryObject!)
                }
            case false:
                print(response.result.error!)
            }
        }
    }
    
    static func get(url: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping([String: Any]) -> Void) {
        Alamofire.request(BASE_URL + url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                let value = response.result.value!
                let json = JSON(value)
                print(json)
                if let code = json["code"].int, code == 0 {
                    onSuccess(json.dictionaryObject!)
                } else {
                    onFailure(json.dictionaryObject!)
                }
            case false:
                print(response.result.error!)
            }
        }
    }
}
