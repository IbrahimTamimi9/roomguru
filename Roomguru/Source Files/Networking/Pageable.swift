//
//  Pageable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol Pageable {
    var query: Query { get set }
    var pageToken: String? { get set }
}

extension Pageable {
    
    var pageToken: String? {
        get { return query.parameters?["pageToken"] as? String }
        set { query.parameters?["pageToken"] = newValue }
    }
}
