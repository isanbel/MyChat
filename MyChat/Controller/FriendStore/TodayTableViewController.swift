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
            TodayCommodity(id: "1", title: "指尖的圆舞曲", subTitle: "小众精选", image: UIImage(named: "palominoespresso")!, price: 0, date: Date()),
            TodayCommodity(id: "2", title: "指尖的圆舞曲", subTitle: "小众精选", image: UIImage(named: "palominoespresso")!, price: 0, date: Date())
        ],
        [
            TodayCommodity(id: "3", title: "指尖的圆舞曲", subTitle: "小众精选", image: UIImage(named: "palominoespresso")!, price: 0, date: Date())
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
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
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section" + String(section)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return SCREEN_WIDTH * SCALE_RATE;
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

