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
    var yearsFromNow:   Int { return Calendar.current.dateComponents([.year],       from: self, to: Date()).year        ?? 0 }
    var monthsFromNow:  Int { return Calendar.current.dateComponents([.month],      from: self, to: Date()).month       ?? 0 }
    var weeksFromNow:   Int { return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear  ?? 0 }
    var daysFromNow:    Int { return Calendar.current.dateComponents([.day],        from: self, to: Date()).day         ?? 0 }
    var hoursFromNow:   Int { return Calendar.current.dateComponents([.hour],       from: self, to: Date()).hour        ?? 0 }
    var minutesFromNow: Int { return Calendar.current.dateComponents([.minute],     from: self, to: Date()).minute      ?? 0 }
    var secondsFromNow: Int { return Calendar.current.dateComponents([.second],     from: self, to: Date()).second      ?? 0 }
    var relativeTime: String {
        if yearsFromNow   > 0 { return "\(yearsFromNow) 年前" }
        if monthsFromNow  > 0 { return "\(monthsFromNow) 月前" }
        if weeksFromNow   > 0 { return "\(weeksFromNow) 周前" }
        if daysFromNow    > 0 { return daysFromNow == 1 ? "昨天" : "\(daysFromNow) 天前" }
        if hoursFromNow   > 0 { return "\(hoursFromNow) 小时前" }
        if minutesFromNow > 0 { return "\(minutesFromNow) 分钟前" }
        if secondsFromNow >= 0 { return secondsFromNow < 15 ? "现在"
            : "\(secondsFromNow) 秒前" }
        return ""
    }
}
