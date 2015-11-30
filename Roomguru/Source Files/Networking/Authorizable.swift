//
//  Authorizable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias QueryAuthorization = (key: String, value: String)

/// Use this protocol to be able to append key=api_key pair for authorization
protocol Authorizable {
    var queryAuthorization: QueryAuthorization { get }
}
