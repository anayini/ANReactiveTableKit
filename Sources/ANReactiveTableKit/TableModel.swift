//
//  TableModel.swift
//  ANReactiveTableKit
//
//  Created by Arjun Nayini on 9/25/19.
//  Copyright © 2019 Arjun Nayini. All rights reserved.
//

import Foundation
import UIKit

public struct TableModel {
    let sections: [TableSectionModel]
    public init(sections: [TableSectionModel]) {
        self.sections = sections
    }
}
