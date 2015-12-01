//
//  Requestable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async
import SwiftyJSON

/**
 *  Requestable
 *  Defines how Requestable type should behave
 */
protocol Requestable {
    var query: Query { get }
    var foundationRequest: NSURLRequest { get }
    var dataTask: NSURLSessionDataTask? { get set }
}

// MARK: - Common implementation for Requestable
extension Requestable {
    
    var foundationRequest: NSURLRequest {
        
        var queryItems = query.parameters?.queryItems
        
        var addHTTPBody = true
        
        if let _ = query as? EventQuery {
            if queryItems?.count>0 {
                addHTTPBody = false
            }
        }
    
        if let authorizable = query as? Authorizable {
            let queryAuth = authorizable.queryAuthorization
            queryItems?.append(NSURLQueryItem(name: queryAuth.key, value: queryAuth.value))
        }
    
        let components = NSURLComponents()
        components.scheme = query.service.scheme
        components.host = query.service.host
        components.path = query.path
        components.queryItems = queryItems
        
        //replacing needed because of passing dates with timezone
        let urlString = components.string!.stringByReplacingOccurrencesOfString("+", withString: "%2B")
        let destinationURL = NSURL(string: urlString)
        
        // Intentionally force unwrapping optional to get crash when problem occur
        let mutableRequest = NSMutableURLRequest(URL: destinationURL!)
        mutableRequest.HTTPMethod = query.method.rawValue
        if addHTTPBody == true {
            mutableRequest.HTTPBody = query.parameters?.body
        }
        
        if mutableRequest.HTTPBody != nil {
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        query.service.authorizeRequest(mutableRequest)
        
        return mutableRequest
    }
    
    mutating func resume(success: ResponseBlock, failure: ErrorBlock) {
        dataTask = session.dataTaskWithRequest(foundationRequest) { (data, response, error) -> Void in
            
            if let error = self.checkResponseForError(response, withError: error) {
                Async.main {
                    failure(error: error)
                }
                return
            }
            
            if let responseData = data {
                var swiftyJSON: JSON? = nil
                var serializationError: NSError?
                
                Async.background {
                    swiftyJSON = JSON(data: responseData, options: .AllowFragments, error: &serializationError)
                }.main {
                    if let serializationError = serializationError {
                        failure(error: serializationError)
                    } else {
                        success(response: swiftyJSON)
                    }
                }
            } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 204 {
                Async.main {
                    success(response: nil)
                }
            } else {
                let message = NSLocalizedString("Failed retrieving data", comment: "")
                let otherError = NSError(message: message)
                
                Async.main {
                    failure(error: otherError)
                }
            }
        }
        
        dataTask?.resume()
    }
    
    mutating func cancel() {
        dataTask?.cancel()
        dataTask = nil
    }
}

// MARK: - Private extension of Requestable
extension Requestable {
    
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func checkResponseForError(response: NSURLResponse?, withError error: NSError?) -> NSError? {
        if let response = response as? NSHTTPURLResponse {
            if response.statusCode == 401 {
                return NSError(message: NSLocalizedString("Authorization expired. Please log in again.", comment: ""))
            } else if response.statusCode >= 400 {
                return NSError(message: NSLocalizedString("Failed retrieving data", comment: ""))
            }
        }
        return error
    }
}
