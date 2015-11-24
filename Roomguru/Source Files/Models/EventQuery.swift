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
    
    // MARK: Initializers
    init() {
        method = .POST
        path = "/calendars/primary/events"
        parameters = Parameters(encoding: Parameters.Encoding.JSON)
        status = .Confirmed
    }
    
    mutating func populateQueryWithCalendarEntryAndUpdateEventDescription(calendarEntry: CalendarEntry) {
        populateQueryWithCalendarEntry(calendarEntry)
        eventDescription = calendarEntry.event.eventDescription
    }
    
    // MARK: Parameters
    
    var eventDescription: String? {
        get { return parameters?[Key.Description.rawValue] as? String }
        set { parameters?[Key.Description.rawValue] = newValue }
    }
    
    var recurrence: String? {
        get {
            if let recurrences = parameters?[Key.Recurrence.rawValue] as? [String] {
                return recurrences.first
            }
            return nil
        }
        set {
            if let recurrence = newValue {
                parameters?[Key.Recurrence.rawValue] = [recurrence]
            }
        }
    }
    
    // MARK: Keys
    private enum Key: String {
        case Description = "description"
        case Recurrence = "recurrence"
    }
}
