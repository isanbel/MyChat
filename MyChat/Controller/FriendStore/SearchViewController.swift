//
//  SearchViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 2018/4/20.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        setUpSearchBar()
    }

    private func setUpSearchBar() {
        searchBar.setValue("取消", forKey: "cancelButtonText")
        searchBar.placeholder = "搜索好友商店"
        searchBar.barTintColor = .white
        searchBar.tintColor = UIColor(hex: "#777777")
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .white
        let searchField = searchBar.value(forKey: "searchField") as? UITextField
        searchField?.backgroundColor = UIColor(hex: "#f1f1f1")
        searchField?.layer.cornerRadius = (searchField?.layer.bounds.height)! / 2
    }
}
