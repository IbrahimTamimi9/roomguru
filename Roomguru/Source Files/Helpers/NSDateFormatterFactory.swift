//
//  NSDateFormatterFactory.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    class func googleDateFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = NSTimeZone.localTimeZone()
        return formatter
    }
}
