# ANReactiveTableKit

*A React-style API for UITableView heavily influenced by [ReactiveLists](github.com/plangrid/ReactiveLists).*

`ANReactiveTableKit` allows you to easily separate the data backing your `UITableView`, the generation of your view models, and the rendering of your `UITableView`.  It does this by giving you a declarative way of describing how your state maps into a view model for your `UITableView`.  Once you tell the library _what_ you want, it will figure out _how_ to do it.  You never need to call `reloadData()` or `performBatchUpdates(_:completion:)`.  Instead, just tell `ANReactiveTableKit` when your state changes and provide a way to map your state into a description of what the table should look like and `ANReactiveTableKit` will handle all the rendering.

`ANReactiveTableKit` is an experiment in providing a similar React-style API as ReactiveLists.  It requires iOS 13+ to be able to use some of the latest APIs to simplify what ReactiveLists does and eliminate the need for any third party dependencies.

After working on ReactiveLists at PlanGrid, I wanted to see if I could simplify the library by using the latest Apple APIs.  To do this, this library requires iOS 13+, which is a constraint that ReactiveLists is unable to do at this time.

The primary additions I'm excited about are:
- Using [UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource), which lets us avoid having to think about diffing and batching update operations for the `UITableView` when data changes.
- Using [Combine](https://developer.apple.com/documentation/combine), which allows us to inject a [Subject](https://developer.apple.com/documentation/combine/subject), which provides a stream of values representing the data source for the `UITableView`.


## Quick Example Usage

1. Define a `struct` that represents the state of your table.  The struct should contain whatever data is needed to render the table you want.  You can think of this as `ANReactiveTableKit`'s idea of a data source.

1. Make your state `struct` conform to `TableModelConvertible`, which is a protocol that describes how to transform your state into a view model representation for `ANReactiveTableKit`.

1. Create a `Combine` `CurrentValueSubject` that produces instances of your `struct`

1.  Create a `TableCoordinator` and pass a reference to your `UITableView` and your `CurrentValueSubject`

1. Whenever you want your table to update, just send a new value to your `CurrentValueSubject`

```swift
struct TableState: TableModelConvertible { ... }

final class TableViewController: UITableViewController {

    var tableCoordinator: TableCoordinator<TableState>?
    var state = CurrentValueSubject<TableState, Never>(TableState())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDriver = TableCoordinator(subject: self.state, tableView: self.tableView)
        
        // Use self.state.send(), to send new `TableState`s and the `TableCoordinator` will automatically
        // rerender your table.
    }
}
```

## Requirements

* Xcode 11.0+
* iOS 13+

## Installation

This code is currently only available as a Swift Package.  You can follow the instructions [here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) to learn how to add a Swift Package to your project from Xcode.

## Detailed Example Project

See the [ANReactiveTableKitExample](https://github.com/anayini/ANReactiveTableKitExample) repo for an example of using this library.
