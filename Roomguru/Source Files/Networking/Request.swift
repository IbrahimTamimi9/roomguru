//
//  Request.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/**
 *  Request
 *  Requestable value type
 */
struct Request: Requestable {
    let query: Query
    var dataTask: NSURLSessionDataTask?

    init(_ query: Query) {
        self.query = query
    }
}
