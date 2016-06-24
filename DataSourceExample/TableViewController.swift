//
//  TableViewController.swift
//  DataSourceExample
//
//  Created by luojie on 16/6/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

///------ 3 ------

struct CustomModel {
    var id: Int
}

class TableViewController: UITableViewController {
    
    let dataSource = DataSource<CustomModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView
        
        dataSource.configureCell = { tableView, item in
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
            cell.textLabel?.text = "CustomModel: " + item.id.description
            return cell
        }
        
        dataSource.items = [
            CustomModel(id: 1),
            CustomModel(id: 2),
            CustomModel(id: 3),
            CustomModel(id: 4),
            CustomModel(id: 5),
            CustomModel(id: 6),
            CustomModel(id: 7),
            CustomModel(id: 8),
            CustomModel(id: 9),
            CustomModel(id: 10),
        ]
    }
}

//class TableViewController: UITableViewController {
//    
//    let dataSource = DataSource<Int>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        dataSource.tableView = tableView
//        
//        dataSource.configureCell = { tableView, item in
//            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
//            cell.textLabel?.text = "Int: " + item.description
//            return cell
//        }
//        
//        dataSource.items = [
//            1,
//            2,
//            3,
//            4,
//            5,
//            6,
//            7,
//            8,
//            9,
//            10,
//        ]
//    }
//}



///------ 2 ------

//class TableViewController: UITableViewController {
//    
//    let dataSource = DataSource()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        dataSource.tableView = tableView
//        
//        dataSource.configureCell = { tableView, text in
//            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
//            cell.textLabel?.text = text
//            return cell
//        }
//        
//        dataSource.texts = [
//            "String 1",
//            "String 2",
//            "String 3",
//            "String 4",
//            "String 5",
//            "String 6",
//            "String 7",
//            "String 8",
//            "String 9",
//            "String 10",
//        ]
//    }
//}

///------ 1 ------


//class TableViewController: UITableViewController {
//    
//    var texts = [String]() {
//        didSet { tableView.reloadData() }
//    }
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return texts.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
//        cell.textLabel?.text = texts[indexPath.row]
//        return cell
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        texts = [
//            "String 1",
//            "String 2",
//            "String 3",
//            "String 4",
//            "String 5",
//            "String 6",
//            "String 7",
//            "String 8",
//            "String 9",
//            "String 10",
//        ]
//    }
//    
//}
