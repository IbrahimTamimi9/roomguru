//
//  AttendeeSpec.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 06/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick
import SwiftyJSON

@testable import Roomguru

extension Attendee {
        
    var rawStatus: String {
        get { return status.rawValue }
    }
}

class AttendeeSpec: QuickSpec {
    
    override func spec() {
        
        let factory = ModelObjectFactory(modelObjectClass: Attendee.self)
        factory.map = { return Attendee.map($0) as [Attendee]? }
        
        let map = [
            "displayName": "name",
            "email": "email",
            "responseStatus": "rawStatus"
        ] as [String: String]
        
        context("correct json") {
            
            itBehavesLike("model object") {
                let localJSON = JSON([
                    "displayName": "fixtureName",
                    "email": "fixtureEmail",
                    "responseStatus": "accepted"
                ])
                
                return [
                    "factory": factory,
                    "json": TestJSON(json: localJSON),
                    "map": map
                ]
            }
        }
        
        context("incorrect json") {
            
            itBehavesLike("model object") {
                let localJSON = JSON([
                    "displayName": "fixtureName",
                    "email": "fixtureEmail",
                    "responseStatus": "fixtureIncorrectStatus"
                ])
                
                let expectedJSON = JSON([
                    "displayName": "fixtureName",
                    "email": "fixtureEmail",
                    "responseStatus": "unknown"
                ])
                
                return [
                    "factory": factory,
                    "json": TestJSON(json: localJSON),
                    "expectedJSON": TestJSON(json: expectedJSON),
                    "map": map
                ]
            }
        }
    }
}
