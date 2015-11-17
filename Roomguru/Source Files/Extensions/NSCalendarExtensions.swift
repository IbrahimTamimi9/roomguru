//
//  NSCalendarExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension NSCalendar {
    
    func mondayDateInWeekDate(date: NSDate) -> NSDate {

        let components = self.components(.Weekday, fromDate: date)

        if components.weekday == firstWeekday {
            return date
        }
        return date
    }
}
