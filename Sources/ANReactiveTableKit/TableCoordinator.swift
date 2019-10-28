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

public protocol TableModelConvertible {
    func tableModel() -> TableModel
}

public final class TableCoordinator<T: TableModelConvertible>: NSObject, UITableViewDelegate {
    private let _tableView: UITableView
    private let _dataSource: ANListKitDiffableDataSource<T>
    private let _tableSubject: CurrentValueSubject<T, Never>

    public init(
        subject: CurrentValueSubject<T, Never>,
        tableView: UITableView
    ) {
        self._tableView = tableView
        self._tableSubject = subject
        self._dataSource = ANListKitDiffableDataSource(
            tableView: tableView
        ) { tableView, sectionViewModel, cellViewModel in return nil }
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

private class ANListKitDiffableDataSource<T: TableModelConvertible>: UITableViewDiffableDataSource<String, String> {
    let cellProvider: ANListKitCellProvider
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

    init(tableView: UITableView, cellProvider: @escaping ANListKitCellProvider) {
        self.cellProvider = cellProvider
        self.tableModel = TableModel(sections: [])
        // We want to use our own type of provider function, so we call the superclass initializer with
        // a noop cell provider and then override `tableView(tableView:cellForRowAt:)`
        // to use an `ANListKitCellProvider`
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
