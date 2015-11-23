//
//  Pageable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Alamofire

protocol Pageable: Query {
    var pageToken: String? { get set }
}

extension Pageable {
    
    var pageToken: String? {
        get { return parameters[PageTokenKey] }
        set { parameters[PageTokenKey] = newValue }
    }
    
    // MARK: Private
    
    private let PageTokenKey = "pageToken"
}
