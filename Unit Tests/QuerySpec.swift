//
//  QuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 14.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class QuerySpec: QuickSpec {

    override func spec() {
        
        let fixtureURLExtension = "FixtureURLExtension"
        
        describe("when initializing") {
            
            let mockQuery = MockQuery(HTTPMethod:"POST", URLExtension: fixtureURLExtension, parameterEncoding: "URL")
            let sut = Query(Alamofire.Method.POST, URLExtension: fixtureURLExtension, parameters: nil, encoding: .URL)
            
            itBehavesLike("queryable") {
                [
                    "sut": sut,
                    "mockQuery": mockQuery,
                ]
            }
        }
    }
}
