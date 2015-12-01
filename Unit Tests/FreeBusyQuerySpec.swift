//
//  FreeBusyQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 12.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import Timepiece

@testable import Roomguru

class FreeBusyQuerySpec: QuickSpec {
    
    override func spec() {
        
        let fixtureCalendarIDs = ["FixtureCalendarID.1", "FixtureCalendarID.2", "FixtureCalendarID.3"]
        var sut: FreeBusyQuery!
        let expectedParameters = Parameters(encoding: Parameters.Encoding.JSON)
        let mockQuery = MockQuery(method: Roomguru.Method.POST, path: "/freeBusy", parameters: expectedParameters, service: GoogleCalendarService())
        let fixtureSearchTimeRange: TimeRange = (min: NSDate().beginningOfDay, max: NSDate().beginningOfDay + 2.days)
        
        
        describe("when initializing") {
            sut = FreeBusyQuery(calendarsIDs: fixtureCalendarIDs, searchTimeRange: fixtureSearchTimeRange)
            
            itBehavesLike("query") {
                [
                    "sut": QueryBox(query: sut),
                    "mockQuery": QueryBox(query: mockQuery),
                ]
            }
        }
    }
}
