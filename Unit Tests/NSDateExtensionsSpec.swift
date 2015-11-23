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
        
        var sut : NSDate!
        
        describe("NSDateExtensions"){
            
            beforeEach {
                sut = NSDate()
            }
            
            afterEach {
                sut = nil
            }
            
            context("checking if date meets conditions") {
                
                it("is not same day as 19.11.2015") {
                    let fixtureDate = self.createDateWithParameters(year: 2015, month: 11, day: 19)
                    
                    expect(sut.isSameDayAs(fixtureDate)).notTo(beTruthy())
                }
                
                it("is today") {
                    expect(sut.isToday()).to(beTruthy())
                }
                
                it("is earlier than today") {
                    expect(NSDate(timeIntervalSince1970: 1410).isEarlierThanToday()).to(beTruthy())
                }
                
                it("today is between year 2000 and 2020") {
                    let startDate = self.createDateWithParameters(year: 2000)
                    let endDate = self.createDateWithParameters(year: 2020)
                    
                    expect(sut.between(start: startDate, end: endDate)).to(beTruthy())
                }
            }
            
            context("making operations on dates") {
                
                let fixtureDate = self.createDateWithParameters(year: 2015, month: 11, day: 20)
                
                let dayAfterFixtureDate = self.createDateWithParameters(year: 2015, month: 11, day: 21)
                
                let dayBeforeFixtureDate = self.createDateWithParameters(year: 2015, month: 11, day: 19)
                
                it("should return 10000 as interval between two dates") {
                    let startDate = NSDate(timeIntervalSince1970: 1448013644)
                    let endDate = NSDate(timeIntervalSince1970: startDate.timeIntervalSince1970+10000)
                    
                    expect(NSDate.timeIntervalBetweenDates(start: startDate, end: endDate)).to(equal(10000))
                }
                
                it("rounds to hours") {
                    let notRoundedDate = self.createDateWithParameters(year: 2000, hour: 10, minute: 12)
                    let exactDate = self.createDateWithParameters(year: 2000, hour: 10)
                    
                    expect(notRoundedDate.roundTo(.Hour, interpolation: .Round)).to(equal(exactDate))
                }
                
                it("returns previous day") {
                    expect(fixtureDate.previousDateWithGranulation(.Day, multiplier: 1)).to(equal(dayBeforeFixtureDate))
                }
                
                it("returns next day") {
                    expect(fixtureDate.nextDateWithGranulation(.Day, multiplier: 1)).to(equal(dayAfterFixtureDate))
                }
                
                it("should subtract one day from date") {
                    expect(fixtureDate--).to(equal(dayBeforeFixtureDate))
                }
                
                it("should add one day to date") {
                    expect(fixtureDate++).to(equal(dayAfterFixtureDate))
                }
            }
        }
    }
    
    func createDateWithParameters(year year: Int, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> NSDate! {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month ?? 1
        dateComponents.day = day ?? 1
        dateComponents.hour = hour ?? 0
        dateComponents.minute = minute ?? 0
        dateComponents.second = second ?? 0
        return NSCalendar.currentCalendar().dateFromComponents(dateComponents)
    }
}
