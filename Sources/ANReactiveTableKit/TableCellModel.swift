//
//  TableCellModel.swift
//  ANReactiveTableKit
//
//  Created by Arjun Nayini on 9/25/19.
//  Copyright © 2019 Arjun Nayini. All rights reserved.
//

import Foundation
import UIKit

/// Protocol which represents a `UITableViewCell` View Model.  Conformers
/// can be used to generate a customized cell in the `UITableView`.
public protocol TableCellViewModel: StringIdentifiable {
    var id: String { get }
    var registrationInfo: ViewRegistrationInfo { get }
    var height: Float { get }
    var didSelect: DidSelectClosure? { get }

    func apply(to cell: UITableViewCell)
}

extension TableCellViewModel {
    var rowHeight: Float? { return nil }
    var didSelect: DidSelectClosure? { return nil }
}

public protocol StringIdentifiable {
    var id: String { get }
}
