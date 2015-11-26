//
//  CalendarEntry.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class CalendarEntry: NSObject, NSSecureCoding {
    
    var calendarID: String = ""
    var event = Event()
    
    init(calendarID: String, event: Event) {
        self.calendarID = calendarID
        self.event = event
        super.init()
    }
    
    class func calendarEntries(calendarID: String, events: [Event]) -> [CalendarEntry] {
        return events.map { CalendarEntry(calendarID: calendarID, event: $0) }
    }
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        if let calendarID = aDecoder.decodeObjectForKey("calendarID") as? String {
            self.calendarID = calendarID
        }
        
        if let event = aDecoder.decodeObjectOfClass(Event.self, forKey: "event") {
            self.event = event
        }
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.calendarID, forKey: "calendarID")
        aCoder.encodeObject(self.event, forKey: "event")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
}

extension CalendarEntry {
    
    class func sortedByDate(items: [CalendarEntry]) -> [CalendarEntry] {
        return items.sort { $0.event.start.compare($1.event.start) == .OrderedAscending }
    }
}
