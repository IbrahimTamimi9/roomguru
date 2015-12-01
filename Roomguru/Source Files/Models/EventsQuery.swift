//
//  EventsQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct EventsQuery: Query, Authorizable {

    /// Query conformance
    let method: Method
    let path: String
    var parameters: Parameters?
    let service: SecureNetworkService = GoogleCalendarService()
    
    let queryAuthorization = (key: "key", value: Constants.Google.Calendars.APIKey)
    
    private let formatter = NSDateFormatter.googleDateFormatter()
    
    // MARK: Initializers
    init(calendarID: String, timeRange: TimeRange) {
        method = .GET
        path = Constants.Google.Calendars.APIVersion + "/calendars/" + calendarID + "/events"
        parameters = Parameters(encoding: Parameters.Encoding.URL)
        
        self.calendarID = calendarID
        
        maxResults = 100
        singleEvents = true
        orderBy = "startTime"
        timeMin = timeRange.min
        timeMax = timeRange.max
    }
    
    // MARK: Parameters
    
    var calendarID: String = ""
    
    var maxResults: Int? {
        get { return parameters?[Key.MaxResults.rawValue] as! Int? }
        set { parameters?[Key.MaxResults.rawValue] = newValue }
    }
    
    var timeMax: NSDate? {
        get { return formatter.dateFromString(parameters?[Key.TimeMax.rawValue] as! String) }
        set {
            if let newTimeMax: NSDate = newValue {
                parameters?[Key.TimeMax.rawValue] = formatter.stringFromDate(newTimeMax)
            } else {
                parameters?[Key.TimeMax.rawValue] = nil
            }
        }
    }
    
    var timeMin: NSDate? {
        get { return formatter.dateFromString(parameters?[Key.TimeMin.rawValue] as! String) }
        set {
            if let newTimeMin: NSDate = newValue {
                parameters?[Key.TimeMin.rawValue] = formatter.stringFromDate(newTimeMin)
            } else {
                parameters?[Key.TimeMin.rawValue] = nil
            }
        }
    }
    
    var orderBy: String? {
        get { return parameters?[Key.OrderBy.rawValue] as! String? }
        set { parameters?[Key.OrderBy.rawValue] = newValue }
    }
    
    var singleEvents: Bool? {
        get {
            let singleEve = parameters?[Key.SingleEvents.rawValue] as! String
            return (singleEve == "true") as Bool?
        }
        set {
            parameters?[Key.SingleEvents.rawValue] = (newValue != nil) ? "true" : nil
        }
    }
    
    // MARK: Private
    private enum Key: String {
        case MaxResults = "maxResults"
        case TimeMax = "timeMax"
        case TimeMin = "timeMin"
        case OrderBy = "orderBy"
        case SingleEvents = "singleEvents"
    }
}

struct EventsPageableQuery: Pageable {
    
    var query: Query
    
    init(query: Query) {
        self.query = query
    }
}

extension EventsQuery {
    
    static func queriesForCalendarIdentifiers(calendars: [String], withTimeRange timeRange: TimeRange) -> [EventsQuery] {
        var queries: [EventsQuery] = []
        
        for calendarID in calendars {
            queries.append(EventsQuery(calendarID: calendarID, timeRange: timeRange))
        }
        
        return queries
    }
}
