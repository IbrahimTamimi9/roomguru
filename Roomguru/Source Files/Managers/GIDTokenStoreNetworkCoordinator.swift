//
//  GIDTokenStoreNetworkCoordinator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

class GIDTokenStoreNetworkCoordinator {
    
    func refreshAccessToken(parameters parameters: [String: AnyObject], completion: ((tokenInfo: (accessToken: String, expirationDate: NSDate)?, error: NSError?)-> Void)) {
        
        Alamofire
            .request(.POST, Constants.GooglePlus.RefreshTokenURL, parameters: parameters)
            .responseJSON { response in
                
                if let error = response.result.error {
                    completion(tokenInfo: nil, error: error)
                    return
                    
                } else if let data: AnyObject = response.result.value {
                    
                    let json = JSON(data)
                    
                    if let accessToken = json["access_token"].string, expiresIn = json["expires_in"].int {
                        
                        let timeInterval = NSTimeInterval(expiresIn)
                        let tokenInfo = (accessToken: accessToken, expirationDate: NSDate().dateByAddingTimeInterval(timeInterval))
                        completion(tokenInfo: tokenInfo, error: response.result.error)
                        return
                    }
                }
                
                let error = NSError(message: NSLocalizedString("Session expired. Please log in again.", comment: ""))
                completion(tokenInfo: nil, error: error)
        }
    }
}
