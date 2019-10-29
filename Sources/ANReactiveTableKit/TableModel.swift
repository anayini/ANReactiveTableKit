//
//  TableModel.swift
//  ANReactiveTableKit
//
//  Created by Arjun Nayini on 9/25/19.
//  Copyright © 2019 Arjun Nayini. All rights reserved.
//

import Foundation
import UIKit

/// View Model that represents the state of the `UITableView`
public struct TableModel {
    let sections: [TableSectionModel]
    public init(sections: [TableSectionModel]) {
        self.sections = sections
    }
}
