//
//  NSDateExtensionsSpec.swift
//  NSDateExtensionTest
//
//  Created by Peter Bruz on 19/11/15.
//  Copyright © 2015 Peter Bruz. All rights reserved.
//

import Nimble
import Quick

class NSDateExtensionsSpec : QuickSpec {
    
    override func spec() {
        
        var now : NSDate!
        
        describe("NSDateExtensions"){
        
            beforeEach {
                now = NSDate()
            }
            
            it("is not same day as 19.11.2015") {
                let dateComponents = NSDateComponents()
                dateComponents.day = 19
                dateComponents.month = 11
                dateComponents.year = 2015
                let fixtureDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
                
                expect(now.isSameDayAs(fixtureDate)).notTo(beTruthy())
            }
            
            it("is today") {
                expect(now.isToday()).to(beTruthy())
            }
            
            it("is earlier than today") {
                expect(NSDate(timeIntervalSince1970: 1410).isEarlierThanToday()).to(beTruthy())
            }
            
            it("today is between year 2000 and 2020") {
                let startDateComponents = NSDateComponents()
                startDateComponents.year = 2000
                let startDate = NSCalendar.currentCalendar().dateFromComponents(startDateComponents)!
                
                let endDateComponents = NSDateComponents()
                endDateComponents.year = 2020
                let endDate = NSCalendar.currentCalendar().dateFromComponents(endDateComponents)!
                
                expect(now.between(start: startDate, end: endDate)).to(beTruthy())
            }
            
            it("should return 10000 as interval between two dates") {
                let startDate = NSDate(timeIntervalSince1970: 1448013644)
                let endDate = NSDate(timeIntervalSince1970: startDate.timeIntervalSince1970+10000)
                
                expect(NSDate.timeIntervalBetweenDates(start: startDate, end: endDate)).to(equal(10000))
            }
            
            it("rounds to hours") {
                let notRoundedDateComponents = NSDateComponents()
                notRoundedDateComponents.minute = 12
                notRoundedDateComponents.hour = 10
                notRoundedDateComponents.day = 1
                notRoundedDateComponents.month = 1
                notRoundedDateComponents.year = 2000
                let notRoundedDate = NSCalendar.currentCalendar().dateFromComponents(notRoundedDateComponents)!
                
                let exactDateComponents = NSDateComponents()
                exactDateComponents.second = 0
                exactDateComponents.minute = 0
                exactDateComponents.hour = 10
                exactDateComponents.day = 1
                exactDateComponents.month = 1
                exactDateComponents.year = 2000
                let exactDate = NSCalendar.currentCalendar().dateFromComponents(exactDateComponents)!
                
                expect(notRoundedDate.roundTo(.Hour, interpolation: .Round)).to(equal(exactDate))
            }
            
            let someDateComponents = NSDateComponents()
            someDateComponents.day = 20
            someDateComponents.month = 11
            someDateComponents.year = 2015
            let someDate = NSCalendar.currentCalendar().dateFromComponents(someDateComponents)!
            
            let dayAfterDateComponents = NSDateComponents()
            dayAfterDateComponents.day = 21
            dayAfterDateComponents.month = 11
            dayAfterDateComponents.year = 2015
            let dayAfter = NSCalendar.currentCalendar().dateFromComponents(dayAfterDateComponents)!
            
            let dayBeforeDateComponents = NSDateComponents()
            dayBeforeDateComponents.day = 19
            dayBeforeDateComponents.month = 11
            dayBeforeDateComponents.year = 2015
            let dayBefore = NSCalendar.currentCalendar().dateFromComponents(dayBeforeDateComponents)!
            
            it("returns previous day") {
                expect(someDate.previousDateWithGranulation(.Day, multiplier: 1)).to(equal(dayBefore))
            }
            
            it("returns next day") {
                expect(someDate.nextDateWithGranulation(.Day, multiplier: 1)).to(equal(dayAfter))
            }
            
            it("should add one day to date") {
                expect(someDate++).to(equal(dayAfter))
            }
            
            it("should subtract one day from date") {
                expect(someDate--).to(equal(dayBefore))
            }
        }
    }
}
