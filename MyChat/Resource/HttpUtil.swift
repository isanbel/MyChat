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
    static let BASE_URL: String = "http://\(Config.SERVER_IP):3000/api"
    
    static func post(url: String, parameters: Parameters, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping([String: Any]) -> Void) {
        Alamofire.request(BASE_URL + url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if (response.result.isSuccess) {
                let value = response.result.value!
                let json = JSON(value)
                print(json)
                if let code = json["code"].int, code == 0 {
                    onSuccess(json.dictionaryObject!)
                } else {
                    onFailure(json.dictionaryObject!)
                }
            } else {
                print(response.result.error!)
            }
        }
    }
    
    static func delete(url: String, parameters: Parameters, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping([String: Any]) -> Void) {
        Alamofire.request(BASE_URL + url, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if (response.result.isSuccess) {
                let value = response.result.value!
                let json = JSON(value)
                print(json)
                if let code = json["code"].int, code == 0 {
                    onSuccess(json.dictionaryObject!)
                } else {
                    onFailure(json.dictionaryObject!)
                }
            } else {
                print(response.result.error!)
            }
        }
    }
    
    static func get(url: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping([String: Any]) -> Void) {
        Alamofire.request(BASE_URL + url).responseJSON { response in
            if (response.result.isSuccess) {
                let value = response.result.value!
                let json = JSON(value)
                print(json)
                if let code = json["code"].int, code == 0 {
                    onSuccess(json.dictionaryObject!)
                } else {
                    onFailure(json.dictionaryObject!)
                }
            } else {
                print(response.result.error!)
            }
        }
    }
    
    static func get_(url: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping() -> Void) {
        Alamofire.request(url).responseJSON { response in
            if (response.result.isSuccess) {
                let value = response.result.value!
                let json = JSON(value)
                print(json)
                onSuccess(json.dictionaryObject!)
            } else {
                onFailure()
                print(response.result.error!)
            }
        }
    }
    
    static func post_(url: String, parameters: Parameters, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping() -> Void) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if (response.result.isSuccess) {
                let value = response.result.value!
                let json = JSON(value)
                print(json)
                onSuccess(json.dictionaryObject!)
            } else {
                onFailure()
                print(response.result.error!)
            }
        }
    }
    
    static func postWithImage(url: String, image: UIImage, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping([String: Any]) -> Void) {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let image_data = UIImageJPEGRepresentation(image, 0.5)
                multipartFormData.append(image_data!, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            },
            usingThreshold: UInt64.init(),
            to: BASE_URL + url,
            method: .post,
            headers: nil,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    static func postWithImage_(url: String, imageName: String, image: UIImage, parameters: [String : Any], onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping([String: Any]) -> Void) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            let image_data = UIImageJPEGRepresentation(image, 0.5)
            multipartFormData.append(image_data!, withName: imageName, fileName: "image.jpg", mimeType: "image/jpg")
        },
            usingThreshold: UInt64.init(),
            to: BASE_URL + url,
            method: .post,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if (response.result.isSuccess) {
                            let value = response.result.value!
                            let json = JSON(value)
                            print(json)
                            if let code = json["code"].int, code == 0 {
                                onSuccess(json.dictionaryObject!)
                            } else {
                                onFailure(json.dictionaryObject!)
                            }
                        } else {
                            print(response.result.error!)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
}
