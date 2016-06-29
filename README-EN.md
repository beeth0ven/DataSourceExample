# DataSourceExample

Shows how to fill data into tableView as simple as possible!

 Simple DataSource
-------

We often use UITableView to show a list of data.
like this:
 
 ```swift
 
class TableViewController: UITableViewController {
    
    var texts = [String]() {
        didSet { tableView.reloadData() }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        texts = [
            "String 1",
            "String 2",
            "String 3",
            "String 4",
            "String 5",
            "String 6",
            "String 7",
            "String 8",
            "String 9",
            "String 10",
        ]
    }
}

 ```
 
Because the logic is vary simple, we try to binding every Element in [String] to Cell.
Work flow:
#### [String] -> String -> Cell
   
   So we **hope** it can be done like this:
   
 ```swift
class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.configureCell = { tableView, text in
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
            cell.textLabel?.text = text
            return cell
        }
        
        tableView.texts = [
            "String 1",
            "String 2",
            "String 3",
            "String 4",
            "String 5",
            "String 6",
            "String 7",
            "String 8",
            "String 9",
            "String 10",
        ]
    }
}

 ```
 It's much simple and more clear.
 
 But it's against **MVC**,
 
 texts is **Model**,
 
 tableView is **View** which should not known what **Model** is.
 
 So the tableView's property **texts** is against **MVC**.
 
 And it's a little difficult for tableView to provide API like this.
 
 We should try something else.
 
 Here shows another way:
 
 ```swift
class TableViewController: UITableViewController {
    
    let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView

        dataSource.configureCell = { tableView, text in
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
            cell.textLabel?.text = text
            return cell
        }

        dataSource.texts = [
            "String 1",
            "String 2",
            "String 3",
            "String 4",
            "String 5",
            "String 6",
            "String 7",
            "String 8",
            "String 9",
            "String 10",
        ]
    }
}

 ```
 It's almost there, So what dose **DataSource** look like?
 
```swift
class DataSource: NSObject, UITableViewDataSource {
    
    var texts = [String]() {
        didSet { tableView.reloadData() }
    }
    
    weak var tableView: UITableView! {
        didSet { tableView.dataSource = self }
    }
    
    var configureCell: ((UITableView, String) -> UITableViewCell)!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(tableView: tableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let text = texts[indexPath.row]
        return configureCell(tableView, text)
    }
}
```
 
DataSource turn tableView's delegate base API to Closure which is Controller needed.

Then fill data.
 
 Work Flow: 
####	TableViewController <-> DataSource <-> UITableView

 Dynamic Element DataSource
-------

We take a look at DataSource's API:

 ```swift
 class DataSource {
 
    var texts = [String]() { get set }
    
    ...
 }
 ```
 
 It's not difficult to find the DataSource can only show [String]，
 
 What if we want to show something else like [Int] or [CustomModel] ,

The DataSource can't work. 
 
We hope DataSource can support any Type.

The Type can be determined dynamic from the context.

**Generic** is the best way to achieve this.

Now, We modify DataSource:

```swift
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
```

How to use：

```swift
 class TableViewController: UITableViewController {
    
    let dataSource = DataSource<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.tableView = tableView

        dataSource.configureCell = { tableView, item in
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")!
            cell.textLabel?.text = "Int: " + item.description
            return cell
        }

        dataSource.items = [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
        ]
    }
}
```
When define DataSource, we leave a placeholder type named **Item**. 

 ```swift
class DataSource<Item>: NSObject, UITableViewDataSource { ... }
 ```
 
 When use DataSource, we fill placeholder type with **Int**.
 
 ```swift
 class TableViewController: UITableViewController {
    
    let dataSource = DataSource<Int>()
    
    ...
    
 }
 ```
 
 Guess what type is dataSource.items in TableViewController.

From definition it's [Item],
 
 ```swift
 class DataSource<Item>: NSObject, UITableViewDataSource {
    
    var items = [Item]() { ... }
    
    ...
}
 ```
 
 And Item is a placeholder type,

 In TableViewController Item = Int.
 
So dataSource.items is [Int]，

Swift is vary smart, He knowns what type is dataSource.items.

He also knowns dataSource.configureCell is 

((UITableView, **Int**) -> UITableViewCell)!

If we pass a different type param, the compiler will give you a warn.

It's the magic of Generic.

For now DataSource can work with Any type as Model:
 
 ```swift
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
 ```
 
 Look back to our work flow:
#### [String] -> String -> Cell

 It's more Generic now：
#### [Item] -> Item -> Cell

What TableViewController need to do is just:

* Fill **Item** with a type
* get data **[Item]**
* transform **Item** to **Cell**

All the other hard work will be done by DataSource,

The work flow is so easy.

The code is much simple.

 summary
-------

We can use what we learn to change the API provided by SDK. 

We love the API which is much simple and easy to use.



