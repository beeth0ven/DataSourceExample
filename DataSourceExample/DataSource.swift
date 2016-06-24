//
//  DataSource.swift
//  DataSourceExample
//
//  Created by luojie on 16/6/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
///------ 3 ------

class DataSource<Item>: NSObject, UITableViewDataSource {
    
    var items = [Item]() {
        didSet { tableView.reloadData() }
    }
    
    weak var tableView: UITableView! {
        didSet { tableView.dataSource = self }
    }
    
    var configureCell: ((UITableView, Item) -> UITableViewCell)!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        return configureCell(tableView, item)
    }
}

///------ 2 ------

//class DataSource: NSObject, UITableViewDataSource {
//
//    var texts = [String]() {
//        didSet { tableView.reloadData() }
//    }
//    
//    weak var tableView: UITableView! {
//        didSet { tableView.dataSource = self }
//    }
//    
//    var configureCell: ((UITableView, String) -> UITableViewCell)!
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return texts.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let text = texts[indexPath.row]
//        return configureCell(tableView, text)
//    }
//}