# DataSourceExample
DataSourceExample

演示,如何简化 UITableView 的搭建。

 简单的 DataSource
-------

我们通常会使用 UITableView 来显示列表页。
代码如下：
 
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
 


   
   由于我们显示的列表页它的逻辑其实很简单，就是将 [String] 中的每个元素绑定到对应的 Cell 上面去，
   流程图:   
#### [String] -> String -> Cell
   
   那么我们希望搭建 TableView 可以这样实现:
   
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
 
 这样写非常简洁，而且非常清晰，
 
 只不过它没有遵循 **MVC** 设计模式，
 
 因为这里的 texts 是 Model,
 
 tableView 是 View，它应该不知道 Model 是什么。
 
 所以 tableView 的 texts 属性违反了 **MVC**，
 
 会使得程序结构混乱。
 
 另外,要使 tableView 提供以上 API (公共方法)  也并不是一件容易的事情。
 
 所以我们要寻找其他的方法，
 
 这里提供另外一个方案：
 
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
 
这个已经非常接近了，那么  DataSource 是什么样的？

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
 

交互是这样的: 
####	TableViewController <-> DataSource <-> UITableView

在这里把 tableView 的 dataSource 传给一个辅助类型 DataSource,

DataSource 将 tableView 的原生的构建方法转换成 TableViewController 所需要的方法，

如此实现了 tableView 数据的填充。
 
 
 动态的 DataSource
-------

我们回顾一下 DataSource 的 API:

 ```swift
 class DataSource {
 
    var texts = [String]() { get set }
    
    ...
 }
 ```
 
 这里不难发现 DataSource 只能用于显示 [String]，
 
 如果需要显示 [Int] 或者 [CustomModel] ,
 
 那么 DataSource 就无法使用了。
 
 

这里我们希望 DataSource 能够支持任意类型的元素，

可以根据使用环境，动态定义元素的类型。

**Generic** 是专门用来解决这类问题的，

现在修改一下 DataSource：

*  1

 ```swift
 class DataSource: NSObject, UITableViewDataSource { ... }
 ```
改为：

 ```swift
class DataSource<Item>: NSObject, UITableViewDataSource { ... }
 ```
 
 
*  2

 ```swift
 var texts = [String]() { ... }
 ```
改为：

 ```swift
 var items = [Item]() { ... }
 ```
 
 
*  3

 ```swift
 var configureCell: ((UITableView, String) -> UITableViewCell)!
 ```
改为：

 ```swift
 var configureCell: ((UITableView, Item) -> UITableViewCell)!
 ```
 
 
*  4

 ```swift
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
 }
 ```
改为：

 ```swift
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
 }
 ```
 
 
*  5

 ```swift
 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let text = texts[indexPath.row]
        return configureCell(tableView, text)
}
 ```
改为：

 ```swift
 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        return configureCell(tableView, item)
 }
 ```

修改完成之后的 DataSource：

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

如何使用它：

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

在定义 DataSource 的时候预留了一个类型 Item 

 ```swift
class DataSource<Item>: NSObject, UITableViewDataSource { ... }
 ```
 
 在使用时，将 Item 的类型填充为 Int
 
 ```swift
 class TableViewController: UITableViewController {
    
    let dataSource = DataSource<Int>()
    
    ...
    
 }
 ```
 
 猜想一下在 TableViewController 中 dataSource.items 是什么类型.
 
 根据 DataSource 的定义，他是 [Item]
 
 ```swift
 class DataSource<Item>: NSObject, UITableViewDataSource {
    
    var items = [Item]() { ... }
    
    ...
}
 ```
 
而 Item 是预留的一个类型，

在 TableViewController 中 Item = Int
 
 ```swift
  let dataSource = DataSource<Int>()
 ```
 
所以 dataSource.items 是 [Int]，

Swift 是非常聪明的，他知道 dataSource.items 的类型

同时,他也知道 dataSource.configureCell 的类型是：

 ((UITableView, **Int**) -> UITableViewCell)!

传值时如果类型不相符，编译器就会提示错误

这也是 Generic 神奇的地方
 
 此时的 DataSource 已经可以支持任意类型的 Model 了:
 
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
 
 回过头来，看下当初的流程图：
#### [String] -> String -> Cell

 现在已经升级为：
#### [Item] -> Item -> Cell


而 TableViewController 需要做的紧紧只是:

* 填充 Item 的类型
* 取得数据 [Item]
* 将 Item 转换为 Cell

其他的工作全部由 DataSource 完成

这样流程很简单，实现也很简单，

代码简洁而且可读性高。

 结尾
-------

以上只是演示一下，如何简化 UITableView 的搭建,

事实上还有许多功能可以加上去，比如选中 Item 的回调:

```swift
 class DataSource<Item>: NSObject, UITableViewDataSource, UITableViewDelegate {
    ...
    var didSelectItem: ((Item) -> UITableViewCell)?
    ...
}
```

在此就不一一例举了。

Swift 是一门神奇的语言，

我们应该试图把他的功能发挥到极限!

License
-------

**DataSourceExample** is under MIT license. See the [LICENSE](LICENSE) file for more info.
 
 


