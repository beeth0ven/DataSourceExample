# DiskVar

 Provide a convenience method to access NSUserDefaults
 
Usage:
------

 ```swift
 class ViewController: UIViewController {
 
    private var history = DiskVar<[String]>(key: "ViewController.history", defaultValue: ["cat"])
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // get
        print(history.value)        // ["cat"]
 
        // set
        history.value.append("dog") // ["cat", "dog"]
 
    }
 
 }

 ```
  
  ViewController's Property "history" is a Array of String which has a defaultValue of ["cat"].
 "ViewController.history" is the key used in NSUserDefaults which should be unique in the project.
 And the history's value will not be lost even if the app is closed.
 
 
License
-------

**DiskVar** is under MIT license. See the [LICENSE](LICENSE) file for more info.
 
 
