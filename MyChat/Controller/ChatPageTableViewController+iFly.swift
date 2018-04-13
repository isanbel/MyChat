//
//  ChatPageTableViewController+iFly.swift
//  MyChat
//
//  Created by Raincome on 26/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import SwiftyJSON

extension ChatPageTableViewController: IFlySpeechRecognizerDelegate {
    func initIfly() {
        IFlySpeechUtility.createUtility("appid=" + Config.IFLY_APPID);
        self.iflySpeechRecognizer.delegate = self;
        self.iflySpeechRecognizer.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        self.iflySpeechRecognizer.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
        
        // 录音设置
        self.iflySpeechRecognizer.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        self.iflySpeechRecognizer.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        self.iflySpeechRecognizer.setParameter("10000", forKey: IFlySpeechConstant.vad_BOS())
        self.iflySpeechRecognizer.setParameter("10000", forKey: IFlySpeechConstant.vad_EOS())
        
        // 设置音频流
        // self.iflySpeechRecognizer.setParameter("-1", forKey: IFlySpeechConstant.audio_SOURCE())
    }
    
    func onError(_ err: IFlySpeechError!) {
        if (err.errorCode == 0) {  // 0 应该是代表服务正常...
            return
        }
        print("识别出错：\(err.errorCode)  \(err.errorDesc!)")
    }
    
    func onResults(_ results: [Any]!, isLast: Bool) {
        var keys = ""
        let dic: Dictionary<String, String> = results[0] as! Dictionary<String, String>
        for key in dic.keys {
            keys += key
        }
        print("识别成功：\(keys)")
        
        let message = keys2Message(keys: keys)
        if (!isLast) {
            self.voice_message += message
        }
        if (isLast && !self.is_recording) {
            sendMessage(self.voice_message)
            self.voice_message = ""
        }
    }
    
    func keys2Message(keys: String) -> String {
        var message = ""
        do {
            let json_data = keys.data(using: String.Encoding.utf8, allowLossyConversion: false)
            let json = try JSON(data: json_data!)
            let ws = json["ws"]
            for (_, ws_each): (String, JSON) in ws {
                let cw = ws_each["cw"]
                print(cw)
                for (_, cw_each): (String, JSON) in cw {
                    message += cw_each["w"].string!
                }
            }
        } catch {
            print(error)
        }
        return message
    }
}
