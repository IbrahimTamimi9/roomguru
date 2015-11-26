//
//  EventsProviderNetworkCooperator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct EventsProviderNetworkCooperator {
    
    let method: Method = .GET
    let path = "/users/me/calendarList"
    var parameters: Parameters? = Parameters(encoding: Parameters.Encoding.URL)
    let service: SecureNetworkService = GoogleCalendarService()
    
    func entriesWithCalendarIDs(calendarIDs: [String], timeRange: TimeRange, completion: (result: [CalendarEntry]?, error: NSError?) -> Void) {
        
        let queries = EventsQuery.queriesForCalendarIdentifiers(calendarIDs, withTimeRange: timeRange)
        let requests = queries.map {
            PageableRequest<Event>($0)
        }
        
        NetworkManager.sharedInstance.chainedRequest(requests, construct: { (request, response: [Event]?) -> [CalendarEntry] in
            
            return self.constructChainedRequestWithQuery(request, response: response)
            
        }, success: { (result: [CalendarEntry]?) in
            completion(result: result, error: nil)
            
        }, failure: { error in
            completion(result: [], error: error)
        })
    }
}

private extension EventsProviderNetworkCooperator {
    
    func constructChainedRequestWithQuery(request: PageableRequest<Event>, response: [Event]?) -> [CalendarEntry] {
        
        if let eventsQuery = request.query as? EventsQuery, response = response {
            return CalendarEntry.calendarEntries(eventsQuery.calendarID, events: response)
        }
        return []
    }
}
