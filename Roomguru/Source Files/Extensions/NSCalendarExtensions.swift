//
//  NSCalendarExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Timepiece

extension NSCalendar {
    
    func mondayDateInWeekDate(date: NSDate) -> NSDate {

        let components = self.components(.Weekday, fromDate: date)

        let mondayIndex = 2
        
        return date - (components.weekday - mondayIndex).day
    }
}
