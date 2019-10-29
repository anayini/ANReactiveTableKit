//
//  TableSectionModel.swift
//  ANReactiveTableKit
//
//  Created by Arjun Nayini on 9/25/19.
//  Copyright © 2019 Arjun Nayini. All rights reserved.
//

import Foundation

/// View model that represents a single section of the `UITableView`
public struct TableSectionModel: StringIdentifiable {
    public let id: String
    let cellViewModels: [TableCellViewModel]
    let headerTitle: String?

    public init(id: String, cellViewModels: [TableCellViewModel], headerTitle: String? = nil) {
        self.id = id
        self.cellViewModels = cellViewModels
        self.headerTitle = headerTitle
    }
}
