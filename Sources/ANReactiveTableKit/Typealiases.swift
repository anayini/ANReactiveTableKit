//
//  Typealiases.swift
//  ANReactiveTableKit
//
//  Created by Arjun Nayini on 9/25/19.
//  Copyright © 2019 Arjun Nayini. All rights reserved.
//

import Foundation
import UIKit

public typealias ANListKitCellProvider = (UITableView, TableSectionModel, TableCellViewModel) -> UITableViewCell?

/// :nodoc:
public typealias DidSelectClosure = () -> Void
