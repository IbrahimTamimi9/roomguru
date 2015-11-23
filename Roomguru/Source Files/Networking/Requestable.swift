//
//  Requestable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

/**
 *  Requestable
 *  Defines how Requestable type should behave
 */
protocol Requestable {
    var query: Query { get }
    var foundationRequest: NSURLRequest { get }
    var dataTask: NSURLSessionDataTask? { get set }
    
    func resume()
    func cancel()
}

// MARK: - Common implementation for Requestable
extension Requestable {
    
    var foundationRequest: NSURLRequest {
        
        let components = NSURLComponents()
        components.scheme = query.service.scheme
        components.host = query.service.host
        components.path = query.path
        components.queryItems = query.parameters?.queryItems
        
        // Intentionally force unwrapping optional to get crash when problem occur
        let mutableRequest = NSMutableURLRequest(URL: components.URL!)
        mutableRequest.HTTPMethod = query.method.rawValue
        mutableRequest.HTTPBody = query.parameters?.body
        
        if mutableRequest.HTTPBody != nil {
            mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        query.service.authorizeRequest(mutableRequest)
        
        return mutableRequest
    }
    
    mutating func resume(success: ResponseBlock, failure: ErrorBlock) {
        dataTask = session.dataTaskWithRequest(foundationRequest) { (data, response, error) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse, error = self.checkResponseForError(httpResponse) ?? error {
                failure(error: error)
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
                success(response: nil)
            } else {
                let message = NSLocalizedString("Failed retrieving data", comment: "")
                let otherError = NSError(message: message)
                
                failure(error: otherError)
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
private extension Requestable {
    
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func checkResponseForError(response: NSHTTPURLResponse?) -> NSError? {
        if response?.statusCode == 401 {
            return NSError(message: NSLocalizedString("Authorization expired. Please log in again.", comment: ""))
        } else if response?.statusCode >= 400 {
            return NSError(message: NSLocalizedString("Failed retrieving data", comment: ""))
        }
        return nil
    }
}
