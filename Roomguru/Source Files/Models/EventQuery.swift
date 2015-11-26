//
//  EventQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 14/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias EventQuery = BookingQuery

extension EventQuery {
        
    mutating func populateQueryWithCalendarEntryAndUpdateEventDescription(calendarEntry: CalendarEntry) {
        populateQueryWithCalendarEntry(calendarEntry)
        eventDescription = calendarEntry.event.eventDescription
    }
    
    // MARK: Parameters
    
    var eventDescription: String? {
        get { return parameters?["description"] as? String }
        set { parameters?["description"] = newValue }
    }
    
    var recurrence: String? {
        get {
            if let recurrences = parameters?["recurrence"] as? [String] {
                return recurrences.first
            }
            return nil
        }
        set {
            if let recurrence = newValue {
                parameters?["recurrence"] = [recurrence]
            }
        }
    }
}
