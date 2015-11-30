//
//  RevokeQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 05.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

@testable import Roomguru

class RevokeQuerySpec: QuickSpec {
        
    override func spec(){
        
        let fixtureEventID = "FixtureIdentifier"
        let fixtureUserEmail = "FixtureUserEmail"
        let URLExtension: String = "/calendars/" + fixtureUserEmail + "/events/" + fixtureEventID
        var sut: RevokeQuery!
        let mockQuery = MockQuery(HTTPMethod: "DELETE", URLExtension: URLExtension, parameterEncoding: "URL")
        
        describe("when initializing") {
            sut = RevokeQuery(eventID: fixtureEventID, userEmail: fixtureUserEmail)
            
            itBehavesLike("queryable") {
                [
                    "sut": sut,
                    "mockQuery": mockQuery,
                ]
            }
        }
    }
}
