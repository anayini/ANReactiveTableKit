//
//  TableCoordinator.swift
//  ANReactiveTableKit
//
//  Created by Arjun Nayini on 9/25/19.
//  Copyright © 2019 Arjun Nayini. All rights reserved.
//

import Combine
import Foundation
import UIKit

public final class TableCoordinator: NSObject {
    private static let _empty = TableModel(sections: [])

    private let _tableView: UITableView
    private let _dataSource: ANListKitDiffableDataSource

    public init(tableView: UITableView) {
        self._tableView = tableView
        self._dataSource = ANListKitDiffableDataSource(
            tableView: tableView,
            tableViewModel: TableCoordinator._empty
        ) { tableView, sectionViewModel, cellViewModel in return nil }
        super.init()
        self._tableView.delegate = self

    }

    public var tableViewModel: TableModel {
        get {
            return _dataSource.tableViewModel
        }
        set {
            self._registerCells(for: newValue)
            _dataSource.tableViewModel = newValue
        }
    }

    private func _registerCells(for tableModel: TableModel) {
        tableModel.sections
            .flatMap { $0.cellViewModels }
            .forEach {
                guard let cellClass = $0.registrationInfo.registeredClass else { return }
                let reuseIdentifier = $0.registrationInfo.reuseIdentifier
                self._tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        }
    }
}

extension TableCoordinator: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableViewModel.sections[indexPath.section].cellViewModels[indexPath.row].didSelect?()
    }
}

private class ANListKitDiffableDataSource: UITableViewDiffableDataSource<String, String> {
    var tableViewModel: TableModel
    let cellProvider: ANListKitCellProvider

    init(tableView: UITableView, tableViewModel: TableModel, cellProvider: @escaping ANListKitCellProvider) {
        self.cellProvider = cellProvider
        self.tableViewModel = tableViewModel
        // We want to use our own type of provider function, so we call the superclass initializer with
        // a noop cell provider and then override `tableView(tableView:cellForRowAt:)`
        // to use an `ANListKitCellProvider`
        super.init(tableView: tableView) { _, _, _ -> UITableViewCell? in return nil }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section <= self.tableViewModel.sections.endIndex else {
            let count = self.tableViewModel.sections.count
            fatalError("Unexpected section index: \(section).  Highest expected index is \(count)")
        }
        return self.tableViewModel.sections[section].cellViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.tableViewModel.sections[indexPath.section].cellViewModels[indexPath.row]
        let reuseIdentifier = cellViewModel.registrationInfo.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellViewModel.apply(to: cell)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section <= self.tableViewModel.sections.endIndex else { return nil }
        return self.tableViewModel.sections[section].headerTitle
    }
}
