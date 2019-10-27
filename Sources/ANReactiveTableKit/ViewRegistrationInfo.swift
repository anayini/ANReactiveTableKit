//
//  ViewRegistrationInfo.swift
//  ANListKitExample
//
//  Created by Arjun Nayini on 9/25/19.
//  Copyright © 2019 Arjun Nayini. All rights reserved.
//

import Foundation
import UIKit

/// Describes a reusable cell and specifies how to register it.
public protocol ReusableCellProtocol {
    var registrationInfo: ViewRegistrationInfo { get }
}

public struct ViewRegistrationInfo: Equatable {

    /// The reuse identifier for the view.
    public let reuseIdentifier: String

    public let registrationMethod: ViewRegistrationMethod

    /// Initializes a new `ViewRegistrationInfo` for the provided `classType`.
    ///
    /// - Parameters:
    ///   - classType: The cell or supplementary view class.
    public init(classType: AnyClass) {
        self.reuseIdentifier = "\(classType)"
        self.registrationMethod = .withClass(classType)
    }

    var registeredClass: AnyClass? {
        switch self.registrationMethod {
        case .withClass(let registeredClass):
            return registeredClass
        }
    }
}

/// The method for registering cells and supplementary views
public enum ViewRegistrationMethod {
    /// Class-based views
    case withClass(AnyClass)
}

extension ViewRegistrationMethod: Equatable {
    public static func == (lhs: ViewRegistrationMethod, rhs: ViewRegistrationMethod) -> Bool {
        switch (lhs, rhs) {
        case let (.withClass(lhsClass), .withClass(rhsClass)):
            return lhsClass == rhsClass
        }
    }
}
