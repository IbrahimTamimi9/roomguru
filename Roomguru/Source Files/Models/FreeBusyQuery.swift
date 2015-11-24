//
//  FreeBusyQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 25/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct FreeBusyQuery: Query {
    
    let method: Method = .POST
    let path: String
    var parameters: Parameters? = Parameters(encoding: Parameters.Encoding.JSON)
    let service: SecureNetworkService = GoogleCalendarService()
    
    private let formatter = NSDateFormatter.googleDateFormatter()
    
    var startDate: NSDate? {
        if let dateString = parameters?[TimeMinKey] as? String {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
    var endDate: NSDate? {
        if let dateString = parameters?[TimeMaxKey] as? String {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
        
    init(calendarsIDs: [String], searchTimeRange: TimeRange) {
        path = "/freeBusy"
        parameters?[Key.Items.rawValue] = calendarsIDs.map { ["id": $0] }
        parameters?[Key.TimeMin.rawValue] = formatter.stringFromDate(searchTimeRange.min)
        parameters?[Key.TimeMax.rawValue] = formatter.stringFromDate(searchTimeRange.max)
        parameters?[Key.TimeZone.rawValue] = "Europe/Warsaw"
    }
    
    // MARK: Private
    private enum Key: String {
        case TimeMax = "timeMax"
        case TimeMin = "timeMin"
        case TimeZone = "timeZone"
        case Items = "items"
    }
}
