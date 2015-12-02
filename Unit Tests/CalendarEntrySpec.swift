//
//  CalendarEntrySpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 10.06.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON

@testable import Roomguru

class CalendarEntrySpec: QuickSpec {
    
    override func spec() {
        
        let fixtureCalendarID = "FixtureCalendarID"
        
        let mockEventFirst = self.mockedEvent("FirstFixtureID", startDate: "2015-04-24T01:00:00+0100", endDate: "2015-04-24T01:30:00+0100")
        let mockEventSecond = self.mockedEvent("SecondFixtureID", startDate: "2015-08-24T01:00:00+0100", endDate: "2015-08-24T01:30:00+0100")
        let mockEventThird = self.mockedEvent("ThirdFixtureID", startDate: "2015-06-24T01:00:00+0100", endDate: "2015-06-24T01:30:00+0100")
        
        let mockEvents = [mockEventFirst, mockEventSecond, mockEventThird]
        
        it("should support secure coding") {
            expect(CalendarEntry.supportsSecureCoding()).to(beTrue())
        }
        
        
        describe("When initialized") {
            
            var sut: CalendarEntry!
            
            beforeEach {
                sut = CalendarEntry(calendarID: fixtureCalendarID, event: mockEventFirst)
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have proper calendar ID") {
                expect(sut.calendarID).to(equal(fixtureCalendarID))
            }
            
            it("should have proper event") {
                expect(sut.event).to(equal(mockEventFirst))
            }
            
            context("after archving") {
                
                var archivedCalendarEntry: NSData!
                
                beforeEach {
                    archivedCalendarEntry = NSKeyedArchiver.archivedDataWithRootObject(sut)
                }
                
                afterEach {
                    archivedCalendarEntry = nil
                }
                
                context("and unarchiving") {
                    
                    var unarchivedCalendarEntry: CalendarEntry!
                    
                    beforeEach {
                        unarchivedCalendarEntry = NSKeyedUnarchiver.unarchiveObjectWithData(archivedCalendarEntry) as! CalendarEntry
                    }
                    
                    afterEach {
                        unarchivedCalendarEntry = nil
                    }
                    
                    it("should calendarEntry have the same calendarID") {
                        expect(sut.calendarID).to(equal(unarchivedCalendarEntry.calendarID))
                    }
                    
                    it("should calendarEntry have the same event identifier") {
                        expect(sut.event.identifier).to(equal(unarchivedCalendarEntry.event.identifier))
                    }
                }
            }
        }
        
        describe("When creating calendar entries array") {
            
            let mockCalendarEntries = self.mockedCalendarEntries(fixtureCalendarID, events: mockEvents)
            let sut = CalendarEntry.calendarEntries(fixtureCalendarID, events: mockEvents)
            
            it("should have proper number of calendar entries") {
                expect(sut.count).to(equal(mockCalendarEntries.count))
            }
            
            it("every calendar should have proper Calendar ID") {
                
                let ownedCalendarIDs = sut.map { $0.calendarID }
                let mockedCalendarIDs = mockCalendarEntries.map { $0.calendarID }
                
                expect(ownedCalendarIDs).to(equal(mockedCalendarIDs))
            }
            
            it("every calendar should have proper event") {
                
                let ownedEvents = sut.map { $0.event }
                let mocekdEvents = mockCalendarEntries.map { $0.event }
                
                expect(ownedEvents).to(equal(mocekdEvents))
            }
        }
        
        describe("When sorting calendar entries by date") {
            
            let unsortedEntries = CalendarEntry.calendarEntries(fixtureCalendarID, events: mockEvents)
            let sortedEntries = unsortedEntries.sort { $0.event.start.compare($1.event.start) == .OrderedAscending }
            let sut = CalendarEntry.sortedByDate(unsortedEntries)
            
            it("should be sorted ascendingly") {
                expect(sut).to(equal(sortedEntries))
            }
        }
    }
}

private extension CalendarEntrySpec {
    
    func mockedEvent(eventID: String, startDate: String, endDate: String) -> Event {
        
        return Event(json: JSON([
            "id" : eventID,
            "summary" : "Fixture summary",
            "status" : "confirmed",
            "htmlLink" : "",
            "start" : ["dateTime" : startDate],
            "end" : ["dateTime" : endDate],
            "attendees" : [
                mockedAttendeeJSONWithName("FixtureName.1", email: "FixtureEmail.1", status: .Awaiting),
                mockedAttendeeJSONWithName("FixtureName.2", email: "FixtureEmail.2", status: .Going),
                mockedAttendeeJSONWithName("FixtureName.3", email: "FixtureEmail.3", status: .Maybe),
                mockedRoomJSONWithName("FixtureRoom.1", email: "FixtureRoomEmail.1"),
                mockedRoomJSONWithName("FixtureRoom.2", email: "FixtureRoomEmail.2")
            ],
            "creator" : mockedAttendeeJSONWithName("FixtureName.4", email: "FixtureEmail.4", status: .Going)
        ]))
    }
    
    func mockedAttendeeJSONWithName(name: String, email: String, status: Status) -> [String : String] {
        return [
            "email" : email,
            "responseStatus" : status.rawValue,
            "displayName" : name
        ]
    }
    
    func mockedRoomJSONWithName(name: String, email: String) -> [String : String] {
        return [
            "email" : email,
            "responseStatus" : Status.Going.rawValue,
            "displayName" : name,
            "self" : String(stringInterpolationSegment: true),
            "resource" : String(stringInterpolationSegment: true)
        ]
    }
    
    func mockedCalendarEntries(calendarID: String, events: [Event]) -> [CalendarEntry] {
        var entries: [CalendarEntry] = []
        for event in events {
            let entry = CalendarEntry(calendarID: calendarID, event: event)
            entries.append(entry)
        }
        return entries
    }
}
