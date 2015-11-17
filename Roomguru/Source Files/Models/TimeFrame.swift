//
//  TimeFrame.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TimeFrameAvailability {
    
    case Available, NotAvailable
}

class TimeFrame: ModelObject {
    
    var startDate = NSDate()
    var endDate = NSDate()
    var availability: TimeFrameAvailability = .NotAvailable
    var duration: NSTimeInterval { return endDate.timeIntervalSinceDate(startDate) }
        
    init(startDate: NSDate, endDate: NSDate, availability: TimeFrameAvailability) {
        self.startDate = startDate
        self.endDate = endDate
        self.availability = availability
        super.init()
    }

    init(startDate: NSDate, endDate: NSDate) {
        super.init(json: JSON([]))
        self.startDate = startDate
        self.endDate = endDate
    }
    
    required init(json: JSON) {
        super.init(json: json)
    }
    
    override func map(json: JSON) {
        if let start = json["start"].string {
            startDate = formatter.dateFromString(start)!
        }
        
        if let end = json["end"].string {
            endDate = formatter.dateFromString(end)!
        }
    }    
}

// MARK: Debug

extension TimeFrame {
    
    override var description: String {
        return "\nstart: \(self.startDate), end: \(self.endDate), duration: \(self.duration), availability: \(self.availability)"
    }
}

extension TimeFrameAvailability: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .Available:
            return "Available"
        case .NotAvailable:
            return "Not available"
        }
    }
}
