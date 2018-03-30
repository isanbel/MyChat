//
//  TodayTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 30/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCALE_RATE: CGFloat = 1.2

class TodayTableViewController: UITableViewController {

    let todayCommodities: [[TodayCommodity]] = [
        [
            TodayCommodity(id: "1", title: "指尖的圆舞曲", subTitle: "小众精选", image: UIImage(named: "u746")!, price: 0, date: Date(), isLightMode: true),
            TodayCommodity(id: "2", title: "准备考四六级了吗", subTitle: "英语词典", image: UIImage(named: "u750")!, price: 0, date: Date(), isLightMode: false)
        ],
        [
            TodayCommodity(id: "3", title: "跳跃，离奇，魔幻", subTitle: "爱讲故事", image: UIImage(named: "u756")!, price: 0, date: Date(), isLightMode: false)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        self.tableView.backgroundColor = UIColor(hex: "#eeeeee")
        
        let dummyViewHeight = CGFloat(80)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        
        self.tableView.register(TodayHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: TodayHeaderTableViewCell.reuseIdentifer)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return todayCommodities.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayCommodities[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TodayTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodayTableViewCell
        
        cell.todayCommodity = todayCommodities[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCellIdentifier = "TodayHeaderTableViewCell"
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellIdentifier) as! TodayHeaderTableViewCell
        
        let titles = ["Header", "sub header"]
        headerCell.titles = titles

        return headerCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return SCREEN_WIDTH * SCALE_RATE;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

extension Date {
    var monthDay: String {
        return "3月31日"
    }
    var weekday: String {
        return "星期一"
    }
}

