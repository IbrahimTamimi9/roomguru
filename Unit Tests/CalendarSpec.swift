//
//  CalendarSpec.swift
//  Roomguru
//
//  Created by Aleksander Popko on 28.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON

@testable import Roomguru

class CalendarSpec: QuickSpec {
    
    override func spec() {
        
        let factory = ModelObjectFactory(modelObjectClass: Calendar.self)
        factory.map = { return Calendar.map($0) as [Calendar]? }
        
        let map = [
            "accessRole": "accessRole",
            "etag": "etag",
            "id": "identifier",
            "kind": "kind",
            "summary": "summary",
            "timeZone": "timezone",
            "backgroundColor": "colorHex"
            ] as [String: String]
            
        itBehavesLike("model object") {
            let localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            return [
                "factory": factory,
                "json": TestJSON(json: localJSON),
                "map": map
            ]
        }
        
        context("calendar identifier contains resource identifier") {
            
            let localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier.resource.calendar.google.com",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            
            it("should be resource") {
                expect(sut.isResource()).to(beTrue())
            }
        }
        
        context("calendar identifier does not contain resource identifier") {
            
            let localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            
            it("should not be resource") {
                expect(sut.isResource()).to(beFalse())
            }
        }
        
        context("calendars with the same identifiers") {
            
            let localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let mockLocalJSON = JSON([
                "accessRole": "differentFixtureAccessRole",
                "etag": "differentFixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "differentFixtureKind",
                "summary": "differentFixtureSummary",
                "timeZone": "differentFixtureTimezone",
                "backgroundColor": "differentFixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            let mockCalendar = Calendar(json: mockLocalJSON)
            
            it("should be equal") {
                expect(sut == mockCalendar).to(beTrue())
            }
        }
        
        context("calendars with different identifiers") {
            
            let localJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "fixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let mockLocalJSON = JSON([
                "accessRole": "fixtureAccessRole",
                "etag": "fixtureEtag",
                "id": "differentFixtureIdentifier",
                "kind": "fixtureKind",
                "summary": "fixtureSummary",
                "timeZone": "fixtureTimezone",
                "backgroundColor": "fixtureColorHex"
                ])
            
            let sut = Calendar(json: localJSON)
            let mockCalendar = Calendar(json: mockLocalJSON)
            
            it("should not be equal") {
                expect(sut == mockCalendar).to(beFalse())
            }
        }

    }
}
