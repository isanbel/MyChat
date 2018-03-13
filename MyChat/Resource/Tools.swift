//
//  Tools.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 04/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation

// Reference: https://stackoverflow.com/questions/27310883/swift-ios-doesrelativedateformatting-have-different-values-besides-today-and
extension Date {
    var daysFromNow: Int { return Calendar.current.dateComponents([.day], from: self, to: Date()).day         ?? 0 }
    var hoursFromNow: Int { return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0 }
    var minutesFromNow: Int { return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0 }
    var secondsFromNow: Int { return Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0 }
    var relativeTime: String {
        let formatter = DateFormatter()
        // 日期
        formatter.dateFormat = "dd/MM/yyyy"
        var date = formatter.string(from: self)
        // 时间
        formatter.dateFormat = "hh:mm"
        var time = formatter.string(from: self)
        if daysFromNow == 0 { date = "今天" }
        if daysFromNow == 1 { date = "昨天" }
        if daysFromNow == 2 { date = "前天" }
        if hoursFromNow == 0 && secondsFromNow >= 0 {
            date = ""
            if minutesFromNow > 0 {
                time = "\(minutesFromNow) 分钟前"
            } else {
                time = secondsFromNow < 15 ? "刚刚" : "\(secondsFromNow) 秒前"
            }
        }
        return date == "" ? time : date + " " + time
    }
}
