//
//  AddFriendTableViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 08/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit

class AddFriendTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        setUpSearchBar()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    private func setUpSearchBar() {
        searchController.searchBar.setValue("取消", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "好友号/角色号"
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = UIColor(hex: "#777777")
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = .white
        let searchField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchField?.backgroundColor = UIColor(hex: "#f1f1f1")
        searchField?.layer.cornerRadius = (searchField?.layer.bounds.height)! / 2
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}
