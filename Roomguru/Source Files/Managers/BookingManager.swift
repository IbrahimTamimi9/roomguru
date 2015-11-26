//
//  BookingManager.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

class BookingManager: NSObject {
    
    lazy var networkManager = NetworkManager.sharedInstance
    var eventsProvider: EventsProvider?
    
    func firstBookableCalendarEntry(calendarIDs calendarIDs: [String], completion: (entry: CalendarEntry?, error: NSError?) -> Void) {
        
        bookableCalendarEntries(calendarIDs: calendarIDs) { (entries, error) in
            
            if let error = error {
                completion(entry: nil, error: error)
                return
            } else if entries == nil {
                completion(entry: nil, error: nil)
                return
            }
            
            // Take calendar entries from one calendar depending on first element, which is the first available free event
            let freeCalendarEntriesWithSameCalendarID = entries!.filter { entries!.first?.calendarID == $0.calendarID }
            
            // No result found:
            if freeCalendarEntriesWithSameCalendarID.isEmpty {
                completion(entry: nil, error: nil)
                return
            }
            
            // Calendar ID and start event is known:
            let freeEventStartDate = freeCalendarEntriesWithSameCalendarID.first!.event.start
            let calendarID = freeCalendarEntriesWithSameCalendarID.first!.calendarID
            
            var freeEventEndDate: NSDate!
            
            // look for end of free event:
            for (index, freeCalendarEntry) in freeCalendarEntriesWithSameCalendarID.enumerate() {
                
                if index == freeCalendarEntriesWithSameCalendarID.count - 1 {
                    freeEventEndDate = freeCalendarEntry.event.end
                    break
                }
                
                if freeCalendarEntry.event.end != freeCalendarEntriesWithSameCalendarID[index + 1].event.start {
                    freeEventEndDate = freeCalendarEntry.event.end
                    break
                }
            }
            
            // return calendar entry with time frames and calendar ID:
            let freeEvent = FreeEvent(startDate: freeEventStartDate, endDate: freeEventEndDate)
            let freeCalendarEntry = CalendarEntry(calendarID: calendarID, event: freeEvent)
            completion(entry: freeCalendarEntry, error: nil)
        }
    }
    
    func bookableCalendarEntries(calendarIDs calendarIDs: [String], completion: (entries: [CalendarEntry]?, error: NSError?) -> Void) {
        
        if eventsProvider == nil {
            eventsProvider = EventsProvider(calendarIDs: calendarIDs, timeRange: NSDate().dayTimeRange)
        }
        eventsProvider!.activeCalendarEntriesWithCompletion { (calendarEntries, error) -> Void in
            
            if let error = error {
                completion(entries: nil, error: error)
                return
            }
            
            // Gather only free events and sort them by date:
            var freeCalendarEntries = calendarEntries.filter { $0.event is FreeEvent }
            freeCalendarEntries.sortInPlace { $0.event.start <= $1.event.start }
            
            completion(entries: freeCalendarEntries, error: nil)
        }
    }
    
    func bookCalendarEntry(calendarEntry: CalendarEntry, completion: (event: Event?, error: NSError?) -> Void) {

        let query = BookingQuery(quickCalendarEntry: calendarEntry)
        networkManager.request(Request(query), success: { response in
            
            if let response = response {
                let event = Event(json: response)
                completion(event: event, error: nil)
            } else {
                let error = NSError(message: NSLocalizedString("Problem booking event occurred", comment: ""))
                completion(event: nil, error: error)
            }
            
        }, failure: { error in
            completion(event: nil, error: error)
        })
    }
    
    func revokeEvent(eventID: String, userEmail: String, completion: (success: Bool, error: NSError?) -> Void) {
        let query = RevokeQuery(eventID: eventID, userEmail: userEmail)
        networkManager.request(Request(query), success: { response in
            completion(success: true, error: nil)
        }, failure: { error in
            completion(success: false, error: error)
        })
    }
}
