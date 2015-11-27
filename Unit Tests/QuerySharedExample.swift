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
            
            var configDict: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
            
            let sut = configDict["sut"] as! Query
            let mockQuery = configDict["mockQuery"] as! MockQuery
            let mockQueryParameters = configDict["mockQueryParameters"] as? Parameters
            
            it("should have proper method") {
                expect(sut.method.rawValue).to(equal(mockQuery.method.rawValue))
            }
            
            it("should have proper path") {
                expect(sut.path).to(equal(mockQuery.path))
            }
            
            context("testing parameters") {
            
                if let mockParameters = mockQueryParameters {
                    
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
            
            //NGRTodo: This was moved to GoogleRequiredAuthProtocol
//            context("setting full path") {
//                
//                let fixtureBaseURL = "FixtureBaseURL"
//                let fixtureAuthKey = "FixtureAuthKey"
//                let mockFullPath = fixtureBaseURL + sut.path + fixtureAuthKey
//                sut.setFullPath(baseURL: fixtureBaseURL, authKey: fixtureAuthKey)
//                
//                it("should have proper full path") {
//                    expect(sut.fullPath).to(equal(mockFullPath))
//                }
//            }
        }
    }
}


func queryDateFormatter() -> NSDateFormatter {
    let formatter: NSDateFormatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZ"
    formatter.timeZone = NSTimeZone.localTimeZone()
    return formatter
}
