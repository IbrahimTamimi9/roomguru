//
//  Pageable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol Pageable: Query {
    var pageToken: String? { get set }
}

extension Pageable {
    
    var pageToken: String? {
        get { return parameters?[Key.PageToken.rawValue] }
        set { parameters?[Key.PageToken.rawValue] = newValue }
    }
    
    // MARK: Private
    private enum Key: String {
        case PageToken = "pageToken"
    }
}
