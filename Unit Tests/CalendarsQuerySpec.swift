//
//  CalendarsQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 05.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

@testable import Roomguru

class CalendarsQuerySpec: QuickSpec {
    
    override func spec() {
        
        var sut: CalendarsQuery!
        let expectedPath = Constants.Google.Calendars.APIVersion + "/users/me/calendarList"
        let expectedParameters = Parameters(encoding: .URL)
        let mockQuery = MockQuery(method: Roomguru.Method.GET, path: expectedPath, parameters: expectedParameters, service: GoogleCalendarService())
        
        describe("when initializing") {
            sut = CalendarsQuery()
            
            itBehavesLike("query") {
                [
                    "sut": QueryBox(query: sut),
                    "mockQuery": QueryBox(query: mockQuery)
                ]
            }
        }
    }
}
