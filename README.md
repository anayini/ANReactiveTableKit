# ANReactiveTableKit

*A React-style API for UITableView heavily influenced by [ReactiveLists](github.com/plangrid/ReactiveLists).*

`ANReactiveTableKit` is an experiment in providing a similar React-style API as ReactiveLists.  It requires iOS 13+ to be able to use some of the latest APIs to simplify what ReactiveLists was attempting to do and eliminate the need for any third party dependencies.

After working on ReactiveLists at PlanGrid, I wanted to see if we could simplify the library by using the latest Apple APIs.  To do this, this library requires iOS 13+, which is something ReactiveLists is unable to do at this time since it is used by customers on older iOS versions.

The primary additions I'm excited about are:
- Using [UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource), which lets us avoid having to think about diffing and batching update operations for the `UITableView` when data changes.
- Using [Combine](https://developer.apple.com/documentation/combine), which allows us to inject a [Subject](https://developer.apple.com/documentation/combine/subject), which provides a stream of values representing the data source for the `UITableView`.

## Requirements

* Xcode 11.0+
* iOS 13+

## Installation

This code is currently only available as a Swift Package.  You can follow the instructions [here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) to learn how to add a Swift Package to your project from Xcode.

## Example Usage

See the [ANReactiveTableKitExample](https://github.com/anayini/ANReactiveTableKitExample) repo for an example of using this library.
