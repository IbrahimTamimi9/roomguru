//
//  QueryableSharedExample.swift
//  Roomguru
//
//  Created by Aleksander Popko on 10.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

@testable import Roomguru

class QueryBox {
    let query: Query
    init(query: Query) { self.query = query }
}

class MockQuery : Query {
    var method: Roomguru.Method
    var path: String
    var parameters: Parameters?
    var service: SecureNetworkService
    
    init(method: Roomguru.Method, path: String, parameters: Parameters?, service: SecureNetworkService){
        self.method = method
        self.path = path
        self.parameters = parameters
        self.service = service
    }
}

class QueryableSharedExample: QuickConfiguration {
    
    override class func configure(configuration: Configuration) {
        sharedExamples("query") { (sharedExampleContext: SharedExampleContext) in
            
            let configDict: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
            
            let queryBox = configDict["sut"] as! QueryBox
            let sut = queryBox.query
            
            let mockQueryBox = configDict["mockQuery"] as! QueryBox
            let mockQuery = mockQueryBox.query
            
            
            it("should have proper method") {
                expect(sut.method.rawValue).to(equal(mockQuery.method.rawValue))
            }
            
            it("should have proper path") {
                expect(sut.path).to(equal(mockQuery.path))
            }
            
            context("testing parameters") {
            
                if let mockParameters = mockQuery.parameters {
                    
                    it("should have proper query items") {
                        expect(sut.parameters?.queryItems).to(equal(mockParameters.queryItems))
                    }
                    
                    it("should have proper encoding") {
                        expect(sut.parameters?.encoding).to(equal(mockParameters.encoding))
                    }
                    
                } else {
                    
                    it("should have nil parameters") {
                        expect(sut.parameters).to(beNil())
                    }
                }
            }
        }
    }
}


func queryDateFormatter() -> NSDateFormatter {
    let formatter: NSDateFormatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
    formatter.timeZone = NSTimeZone.localTimeZone()
    return formatter
}
