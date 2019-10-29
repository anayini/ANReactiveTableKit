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

/// Conformers can produce a `TableModel` representation of themselves.  This is used
/// so that the TableCoordinator can take any  `CurrentValueSubject` that produces
/// a `TableModelConvertible`.   Users only have to conform and pass a `CurrentValueSubject`
/// to the `TableCoordinator`.  This helps separate the state object from `ANReactiveTableKit`
/// and makes the code more testable.
public protocol TableModelConvertible {
    func tableModel() -> TableModel
}

/// `TableCoordinator` is responsible for taking in changing state and automatically updating the
/// `UITableView` to reflect the new state.  Users create a  `TableCoordinator` by passing in
/// a `UITableView` and a `CurrentValueSubject` that produces a `TableModelConvertible`
/// type.  At that point, the user only has to `send()` values to the `CurrentValueSubject` as their
/// data changes and the `TableCoordinator` will efficiently update the `UITableView` UI.
public final class TableCoordinator<T: TableModelConvertible>: NSObject, UITableViewDelegate {
    private let _tableView: UITableView
    private let _dataSource: ANListKitDiffableDataSource
    private let _tableSubject: CurrentValueSubject<T, Never>

    public init(
        subject: CurrentValueSubject<T, Never>,
        tableView: UITableView
    ) {
        self._tableView = tableView
        self._tableSubject = subject
        self._dataSource = ANListKitDiffableDataSource(
            tableView: tableView
        )
        super.init()
        self._tableView.delegate = self
        _ = self._tableSubject.receive(on: RunLoop.main).sink { tableModelConvertible in
            let tableModel = tableModelConvertible.tableModel()
            self._registerCells(for: tableModelConvertible.tableModel())
            self._dataSource.tableModel = tableModel
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableModel = self._tableSubject.value.tableModel()
        tableModel.sections[indexPath.section].cellViewModels[indexPath.row].didSelect?()
    }
}

/// Internal subclass of `UITableViewDiffableDataSource` that handles the updates of the `UITableView`.
class ANListKitDiffableDataSource: UITableViewDiffableDataSource<String, String> {
    var tableModel: TableModel {
        didSet {
            let oldSnapshot = self.snapshot()
            var newSnapshot = oldSnapshot
            newSnapshot.deleteSections(oldSnapshot.sectionIdentifiers)
            newSnapshot.deleteAllItems()
            newSnapshot.appendSections(tableModel.sections.map { $0.id })
            for section in tableModel.sections {
                newSnapshot.appendItems(
                    section.cellViewModels.map { $0.id },
                    toSection: section.id
                )
            }
            self.apply(newSnapshot, animatingDifferences: true)
        }
    }

    init(tableView: UITableView) {
        self.tableModel = TableModel(sections: [])
        super.init(tableView: tableView) { _, _, _ -> UITableViewCell? in return nil }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section <= self.tableModel.sections.endIndex else {
            let count = tableModel.sections.count
            fatalError("Unexpected section index: \(section).  Highest expected index is \(count)")
        }
        return tableModel.sections[section].cellViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.tableModel.sections[indexPath.section].cellViewModels[indexPath.row]
        let reuseIdentifier = cellViewModel.registrationInfo.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellViewModel.apply(to: cell)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section <= self.tableModel.sections.endIndex else { return nil }
        return self.tableModel.sections[section].headerTitle
    }
}
