//
//  BookingQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

enum EventStatus: String {
    case Confirmed = "confirmed"
    case Tentative = "tentative"
    case Cancelled = "cancelled"
}

struct BookingQuery: Query {
    
    /// Query conformance
    let method: Method
    let path: String
    var parameters: Parameters? = Parameters(encoding: Parameters.Encoding.JSON)
    let service: SecureNetworkService = GoogleCalendarService()
    
    private static var URLExtension = "/calendar/v3/calendars/primary/events"
    
    private let formatter = NSDateFormatter.googleDateFormatter()
    private var attendees: [[String: String]] = []
    private let dateFormatter = NSDateFormatter()
    
    // MARK: Initializers
    
    init() {
        method = .POST
        path = BookingQuery.URLExtension
        parameters = Parameters(encoding: Parameters.Encoding.JSON)
        status = .Confirmed
    }
    
    init(calendarEntry: CalendarEntry) {
        method = .PUT
        path = BookingQuery.URLExtension + "/" + calendarEntry.event.identifier!
        commonSetup()
        populateQueryWithCalendarEntry(calendarEntry)
        addAttendees(calendarEntry.event.attendees.filter { $0.email != nil }.map { $0.email! })
    }
    
    init(quickCalendarEntry calendarEntry: CalendarEntry) {
        method = .POST
        path = BookingQuery.URLExtension
        commonSetup()
        populateQueryWithCalendarEntry(calendarEntry)
    }
    
    private mutating func commonSetup() {
        timeZone = NSTimeZone.localTimeZone().name
        dateFormatter.dateFormat = "yyyy-MM-dd"
        addLoggedUserAsAttendee()
    }
    
    // MARK: Parameters
    
    var calendarID = "" {
        willSet { updateCalendarAsAttendee(calendarID, new: newValue) }
    }
    
    var allDay: Bool {
        mutating get { return isAllDay() }
        set {
            if newValue {
                setAllDay(startDate ?? NSDate())
            } else {
                cancelAllDay()
            }
        }
    }
    
    var summary: String {
        get { return parameters?[SummaryKey] as? String ?? "" }
        set { parameters?[SummaryKey] = newValue }
    }
    
    var startDate: NSDate! {
        get { return dateForKey(StartKey) }
        set { setDate(newValue, forKey: StartKey) }
    }
    
    var endDate: NSDate! {
        get { return dateForKey(EndKey) }
        set { setDate(newValue, forKey: EndKey) }
    }
    
    var timeZone: String {
        get { return timeZoneForDateKey(StartKey) }
        set {
            setTimeZone(newValue, forDateKey: StartKey)
            setTimeZone(newValue, forDateKey: EndKey)
        }
    }
    
    var status: EventStatus {
        get {
            if let status = parameters?[StatusKey] as? String {
                return EventStatus(rawValue: status) ?? .Confirmed
            }
            return .Confirmed
        }
        set { parameters?[StatusKey] = newValue.rawValue }
    }
    
    // MARK: Attendees
    
    mutating func addAttendees(emails: [String]) {
        for email in emails {
            addAttendee(email)
        }
    }
    
    mutating func addAttendee(email: String) {
        addAttendeesByDictionary([EmailKey : email])
    }
    
    mutating func setAttendees(emails: [String]) {
        attendees = []
        for email in emails {
            attendees.append([EmailKey : email])
        }
        parameters?[AttendeesKey] = attendees
    }
    
    mutating func removeAttendee(email: String) {
        attendees = attendees.filter { $0[self.EmailKey] != email }
        parameters?[AttendeesKey] = attendees
    }
    
    // MARK: Private keys

    private let AttendeesKey = "attendees"
    private let DateKey = "date"
    private let DateTimeKey = "dateTime"
    private let EmailKey = "email"
    private let EndKey = "end"
    private let ResponseStatusKey = "responseStatus"
    private let StartKey = "start"
    private let StatusKey = "status"
    private let SummaryKey = "summary"
    private let TimeZoneKey = "timeZone"

    // MARK: Private functions
    
    private func dateForKey(key: String) -> NSDate? {
        if let dateDict = parameters?[key] as? [String: String], dateString = dateDict[DateTimeKey] {
            return formatter.dateFromString(dateString)
        }
        return nil
    }
    
    private mutating func setDate(date: NSDate?, forKey key: String) {
        if let date = date {
            var dateDict = [DateTimeKey: formatter.stringFromDate(date)]
            let timeZone = self.timeZone
            
            if !timeZone.isEmpty {
                dateDict[TimeZoneKey] = NSTimeZone.localTimeZone().name
            }
            parameters?[key] = dateDict
        } else {
            parameters?[key] = nil
        }
    }
    
    private func setTimeZone(timeZone: String, forDateKey key: String) {
        if var dateDict = parameters?[key] as? [String: AnyObject] {
            dateDict[TimeZoneKey] = timeZone
        }
    }
    
    private func timeZoneForDateKey(key: String) -> String {
        if let dateDict = parameters?[key] as? [String: AnyObject], timeZone = dateDict[TimeZoneKey] as? String {
            return timeZone
        }
        return NSTimeZone.localTimeZone().name
    }
    
    private mutating func addAttendeesByDictionary(attendeeDict: [String: String]) {
        attendees.append(attendeeDict)
        parameters?[AttendeesKey] = attendees
    }
    
    private mutating func addLoggedUserAsAttendee() {
        if let user = UserPersistenceStore.sharedStore.user {
            addAttendeesByDictionary([
                EmailKey: user.email,
                ResponseStatusKey: "accepted"
            ])
        }
    }
    
    private mutating func updateCalendarAsAttendee(old: String?, new: String) {
        if let old = old { removeAttendee(old) }
        addAttendeesByDictionary([
            EmailKey: new,
            ResponseStatusKey: "accepted"
        ])
    }
    
    private mutating func isAllDay() -> Bool {
        var result = false
        
        if var startDict = parameters?[StartKey] as? [String: AnyObject] {
            result = startDict[DateKey] != nil && startDict[DateTimeKey] == nil
        }
        
        if var endDict = parameters?[EndKey] as? [String: AnyObject] where result {
            result = endDict[DateKey] != nil && endDict[DateTimeKey] == nil
        }
        
        return result
    }
    
    private mutating func setAllDay(date: NSDate) {
        let start = date.beginningOfDay
        let end = date.endOfDay
        
        let startString = dateFormatter.stringFromDate(start)
        let endString = dateFormatter.stringFromDate(end)
        
        if var startDict = parameters?[StartKey] as? [String: AnyObject] {
            startDict[DateKey] = startString
            startDict.removeValueForKey(DateTimeKey)
            parameters?[StartKey] = startDict
        } else {
            parameters?[StartKey] = [
                DateKey: startString,
                TimeZoneKey: timeZone
            ]
        }
        
        if var endDict = parameters?[EndKey] as? [String: AnyObject] {
            endDict[DateKey] = endString
            endDict.removeValueForKey(DateTimeKey)
            parameters?[EndKey] = endDict
        } else {
            parameters?[EndKey] = [
                DateKey: endString,
                TimeZoneKey: timeZone
            ]
        }
    }
    
    private func cancelAllDay() {
        if var startDict = parameters?[StartKey] as? [String: AnyObject] {
            startDict.removeValueForKey(DateKey)
        }
        
        if var endDict = parameters?[EndKey] as? [String: AnyObject] {
            endDict.removeValueForKey(DateKey)
        }
    }
    
    mutating func populateQueryWithCalendarEntry(calendarEntry: CalendarEntry) {
        
        calendarID = calendarEntry.calendarID
        summary = calendarEntry.event.summary ?? ""
        startDate = calendarEntry.event.start
        endDate = calendarEntry.event.end
    }
}
