//
//  EventsProviderNetworkCooperator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class EventsProviderNetworkCooperator {
    
    let method: Method = .GET
    let path = "/users/me/calendarList"
    var parameters: Parameters? = Parameters(encoding: Parameters.Encoding.URL)
    let service: SecureNetworkService = GoogleCalendarService()
    
    func entriesWithCalendarIDs(calendarIDs: [String], timeRange: TimeRange, completion: (result: [CalendarEntry]?, error: NSError?) -> Void) {
        
        let queries: [Pageable] = EventsQuery.queriesForCalendarIdentifiers(calendarIDs, withTimeRange: timeRange) 
        
        NetworkManager.sharedInstance.chainedRequest(queries, construct: { (query, response: [Event]?) -> [CalendarEntry] in
            
            return self.constructChainedRequestWithQuery(query, response: response)
            
        }, success: { (result: [CalendarEntry]?) in
            completion(result: result, error: nil)
            
        }, failure: { error in
            completion(result: [], error: error)
        })
    }
}

private extension EventsProviderNetworkCooperator {
    
    func constructChainedRequestWithQuery(query: Pageable, response: [Event]?) -> [CalendarEntry] {
        
        if let query = query as? EventsQuery, response = response {
            return CalendarEntry.caledarEntries(query.calendarID, events: response)
        }
        return []
    }
}
