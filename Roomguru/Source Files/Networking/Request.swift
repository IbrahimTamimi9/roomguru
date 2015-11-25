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
struct Request<Queryable: Query>: Requestable {
    let query: Queryable
    var dataTask: NSURLSessionDataTask?

    init(_ query: Queryable) {
        self.query = query
    }
}
