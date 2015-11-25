//
//  PageableRequest.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async
import SwiftyJSON

struct PageableRequest<Queryable: Pageable, T: ModelJSONProtocol> : Requestable {
    var query: Queryable
    var dataTask: NSURLSessionDataTask? = nil
    var result: [T] = []

    init(_ query: Queryable) {
        self.query = query
    }
    
    mutating func resume(success: (response: [T]?) -> Void, failure: ErrorBlock) {
        dataTask = session.dataTaskWithRequest(foundationRequest) { (data, response, error) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse, error = self.checkResponseForError(httpResponse) ?? error {
                failure(error: error)
                return
            }
            
            if let responseData = data {
                var swiftyJSON: JSON? = nil
                var serializationError: NSError? = nil
                
                Async.background {
                    swiftyJSON = JSON(data: responseData, options: .AllowFragments, error: &serializationError)
                    let array = swiftyJSON?["items"].array
                    
                    if let result: [T] = T.map(array) {
                        self.result = result
                    }
                    
                }.main {
                    if let serializationError = serializationError {
                        failure(error: serializationError)
                    } else if let pageToken = swiftyJSON?["nextPageToken"].string {
                        self.query.pageToken = pageToken
                        self.resume(success, failure: failure)
                    } else {
                        success(response: self.result)
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
