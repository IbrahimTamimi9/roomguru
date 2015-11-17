//
//  FreeEventsProvider.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 06/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class FreeEventsProvider {
    
    var configuration = TimelineConfiguration()
    
    func populateEntriesWithFreeEvents(entriesToFill: [CalendarEntry], inTimeRange timeRange: TimeRange, usingCalenadIDs calendarIDs: [String]) -> [CalendarEntry] {

        var entries: [CalendarEntry] = []
        var entriesSortedByCalendarIDs: [[CalendarEntry]] = []

        for calendarID in calendarIDs {
            let entriesFromOneCalendar = entriesToFill.filter { $0.calendarID == calendarID }
            entries += populateEntriesWithFreeEvents(entriesFromOneCalendar, inTimeRange: timeRange)
        }
        
        return entries
    }
}

private extension FreeEventsProvider {
    
    /* NOTICE:
     * pass entries ONLY with SAME calendar ID
     */
    func populateEntriesWithFreeEvents(entriesToFill: [CalendarEntry], inTimeRange timeRange: TimeRange) -> [CalendarEntry] {
        
        let sortedEntriesToFill = CalendarEntry.sortedByDate(entriesToFill)
        let timeStep = configuration.timeStep
        var entries: [CalendarEntry] = []
        var referenceDate = timeRange.min
        var index = 0
        
        let calendarID = entriesToFill.first?.calendarID ?? ""
        
        while false /*referenceDate < timeRange.max*/ {
            
            // there is no entry after reference date. Means all active entries has beed populated:
            if index == sortedEntriesToFill.count {
                
                let nextRoundedDate = referenceDate.nextDateWithGranulation(.Second, multiplier: Float(timeStep))
                let timeBetweenReferenceDateAndNextRoundedDate = nextRoundedDate.timeIntervalSinceDate(referenceDate)
                
                if let freeEvent = createFreeEntryWithStartDate(referenceDate, endDate: referenceDate.dateByAddingTimeInterval(timeBetweenReferenceDateAndNextRoundedDate)) {
                    entries.append(CalendarEntry(calendarID: calendarID, event: freeEvent))
                }
                increase(&referenceDate, by: timeBetweenReferenceDateAndNextRoundedDate)
                
            // active entries still exists and should be populated in entries array:
            } else {
                
                let entry = sortedEntriesToFill[index]
                let timeBetweenReferenceDateAndTheClosestEntry = NSDate.timeIntervalBetweenDates(start: referenceDate, end: entry.event.start)
                
                // there is entry in less than next timeStep seconds:
                if timeBetweenReferenceDateAndTheClosestEntry < timeStep && timeBetweenReferenceDateAndTheClosestEntry > 0 {
                    
                    if let freeEvent = createFreeEntryWithStartDate(referenceDate, endDate: entry.event.start) {
                        entries.append(CalendarEntry(calendarID: calendarID, event: freeEvent))
                    }
                    increase(&referenceDate, by: timeBetweenReferenceDateAndTheClosestEntry)
                    
                // there is no entry in next timeStep seconds:
                } else if timeBetweenReferenceDateAndTheClosestEntry >= timeStep {
                    
                    let nextRoundedDate = referenceDate.nextDateWithGranulation(.Second, multiplier: Float(timeStep))
                    let timeBetweenReferenceDateAndNextRoundedDate = NSDate.timeIntervalBetweenDates(start: referenceDate, end: nextRoundedDate)
                    
                    // one of the event ended earlier than in half an hour (google speedy meetings):
                    if timeBetweenReferenceDateAndNextRoundedDate < timeStep {
                        
                        if let freeEvent = createFreeEntryWithStartDate(referenceDate, endDate: referenceDate.dateByAddingTimeInterval(timeBetweenReferenceDateAndNextRoundedDate)) {
                            entries.append(CalendarEntry(calendarID: calendarID, event: freeEvent))
                        }
                        increase(&referenceDate, by: timeBetweenReferenceDateAndNextRoundedDate)
                        
                    } else {
                        
                        if let freeEvent = createFreeEntryWithStartDate(referenceDate, endDate: referenceDate.dateByAddingTimeInterval(timeStep)) {
                            entries.append(CalendarEntry(calendarID: calendarID, event: freeEvent))
                        }
                        increase(&referenceDate, by: timeStep)
                    }
                    
                // add event cause it's event time frame:
                } else {
                    entries.append(entry)
                    increase(&referenceDate, by: entry.event.duration)
                    
                    index++
                }
            }
        }
        
        // at the end add entries which wasn't added by algorithm (eg. are beyond specified timeRange)
        entries += sortedEntriesToFill.filter { !contains(entries, $0) }
        
        return entries
    }
    
    func createFreeEntryWithStartDate(var startDate: NSDate, endDate: NSDate) -> FreeEvent?  {
        
        // cannot book in not declared days
        let weekday = NSCalendar.currentCalendar().component(NSCalendarUnit.Weekday, fromDate: startDate)
        if !configuration.bookingDays.contains(weekday) {
            return nil
        }
        
        // cannot book earlier than defined
        if startDate.timeIntervalSinceDate(startDate.midnight) < configuration.bookingRange.min {
            return nil
        }
        
        // cannot book later than defined
        if startDate.timeIntervalSinceDate(startDate/*.midnight*/) > configuration.bookingRange.max {
            return nil
        }
        
        // If earlier than now, change start date of event.
        // If will pass second condition, it means startDate is around current hour.
        // It it will be past, eventDuration will give minuse value, so next condition will break adding event.
        if !configuration.bookablePast && startDate.isEarlierThanToday()  {
            startDate = NSDate()
        }
        
        let eventDuration = NSDate.timeIntervalBetweenDates(start: startDate, end: endDate)
        
        // cannot be shorter than MinimumEventDuration
        if eventDuration < configuration.minimumEventDuration {
            return nil
        }
        
        return FreeEvent(startDate: startDate, endDate: endDate)
    }
    
    func increase(inout date: NSDate, by timeInterval: NSTimeInterval) {
        date = date.dateByAddingTimeInterval(timeInterval)
    }
}
