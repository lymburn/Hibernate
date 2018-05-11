//
//  Premium.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-11.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import Foundation


public struct Premium {
    public static let PremiumProduct = "Premium"
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Premium.PremiumProduct]
    public static let store = IAPHelper(productIds: Premium.productIdentifiers)
}
