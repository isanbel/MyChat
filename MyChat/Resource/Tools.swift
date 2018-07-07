//
//  Tools.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 04/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import Foundation
import UIKit

// Reference:
// https://stackoverflow.com/questions/27310883/swift-ios-doesrelativedateformatting-have-different-values-besides-today-and
extension Date {
    var daysFromNow: Int { return Calendar.current.dateComponents([.day], from: self, to: Date()).day         ?? 0 }
    var hoursFromNow: Int { return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0 }
    var minutesFromNow: Int { return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0 }
    var secondsFromNow: Int { return Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0 }
    var weekDayCH: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        return weekdays[weekday-1]
    }
    var monthDayCH: String {
        let month = Calendar.current.component(.month, from: self)
        let day = Calendar.current.component(.day, from: self)
        return String(month) + "月" + String(day) + "日"
    }
    var relativeTime: String {
        let formatter = DateFormatter()
        // 日期
        formatter.dateFormat = "dd/MM/yyyy"
        var date = formatter.string(from: self)
        // 时间
        formatter.dateFormat = "hh:mm"
        var time = formatter.string(from: self)
        if daysFromNow > 2 { time = "" }
        if daysFromNow >= 3 && daysFromNow <= 7 {
            date = weekDayCH
        }
        if daysFromNow == 2 { date = "前天" }
        if daysFromNow == 1 { date = "昨天" }
        if daysFromNow == 0 { date = "今天" }
        if hoursFromNow == 0 && secondsFromNow >= 0 {
            date = ""
            if minutesFromNow > 0 {
                time = "\(minutesFromNow) 分钟前"
            } else {
                time = secondsFromNow < 15 ? "刚刚" : "\(secondsFromNow) 秒前"
            }
        }
        return date == "" ? time : ( time == "" ? date : date + " " + time)
    }
    var relativeDetailedTime: String {
        // 两天之前，添加到秒的时间
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let time = formatter.string(from: self)
        return daysFromNow > 2 ? relativeTime + time : relativeTime
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
// Usage:
// var color = UIColor(hex: "#d3d3d3")
extension UIColor {
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init()
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
