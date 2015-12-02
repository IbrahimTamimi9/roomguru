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
        let expectedPath = Constants.Google.Calendars.APIVersion + "/calendars/" + fixtureUserEmail + "/events/" + fixtureEventID
        let expectedParameters = Parameters(encoding: Parameters.Encoding.URL)
        let mockQuery = MockQuery(method: Roomguru.Method.DELETE, path: expectedPath, parameters: expectedParameters, service: GoogleCalendarService())
        var sut: RevokeQuery!
        
        describe("when initializing") {
            sut = RevokeQuery(eventID: fixtureEventID, userEmail: fixtureUserEmail)
            
            itBehavesLike("query") {
                [
                    "sut": QueryBox(query: sut),
                    "mockQuery": QueryBox(query: mockQuery)
                ]
            }
        }
    }
}
