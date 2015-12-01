//
//  EventsQuerySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 11.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

@testable import Roomguru

class EventsQuerySpec: QuickSpec {
    
    override func spec() {
        
        let fixtureCalendarIDs = ["FixtureCalendarID.1", "FixtureCalendarID.2", "FixtureCalendarID.3"]
        let timeRange: TimeRange = (NSDate(timeIntervalSince1970: 0), NSDate(timeIntervalSince1970: 240))
        var mockQueries: [MockQuery] = []
        for calendarID in fixtureCalendarIDs {
            let expectedPath = Constants.Google.Calendars.APIVersion + "/calendars/" + calendarID + "/events"
            let expectedParameters = Parameters(encoding: Parameters.Encoding.JSON)
            let mockQuery = MockQuery(method: Roomguru.Method.GET, path: expectedPath, parameters: expectedParameters, service: GoogleCalendarService())
            mockQueries.append(mockQuery)
        }

        describe ("when initializing single query with single calendar identifier") {
            let sut = EventsQuery(calendarID: fixtureCalendarIDs.first!, timeRange: timeRange)
            
            itBehavesLike("query") {
                [
                    "sut": QueryBox(query: sut),
                    "mockQuery": QueryBox(query: mockQueries.first!)
                ]
            }
            
            it("should have proper order by key") {
                expect(sut.orderBy).to(equal("startTime"))
            }
            
            it("should have single events enabled") {
                expect(sut.singleEvents).to(beTruthy())
            }
            
            it("should have proper max results") {
                expect(sut.maxResults).to(equal(100))
            }
            
            it("should have proper time max") {
                expect(sut.timeMax).to(equal(timeRange.max))
            }
            
            it("should have proper time min") {
                expect(sut.timeMin).to(equal(timeRange.min))
            }
        }
        
        describe ("when creating array of queries from array of calendar identifiers") {
            let sut = EventsQuery.queriesForCalendarIdentifiers(fixtureCalendarIDs, withTimeRange: timeRange)

            it("should return proper number of queries") {
                expect(sut.count).to(equal(fixtureCalendarIDs.count))
            }
            
            it("every calendar should have proper time max") {
                let isTimeMaxProper = self.containsOnlyTrue(sut.map { $0.timeMax == timeRange.max })
                expect(isTimeMaxProper).to(beTrue())
            }
            
            it("every calendar should have proper time min") {
                let isTimeMinProper = self.containsOnlyTrue(sut.map { $0.timeMin == timeRange.min })
                expect(isTimeMinProper).to(beTrue())
            }
        }
    }
}

private extension EventsQuerySpec {
    
    func containsOnlyTrue(flags: [Bool]) -> Bool{
        return !flags.contains(false)
    }
}
