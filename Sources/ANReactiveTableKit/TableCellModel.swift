//
//  TableCellModel.swift
//
//
//  Created by Arjun Nayini on 10/2/19.
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
