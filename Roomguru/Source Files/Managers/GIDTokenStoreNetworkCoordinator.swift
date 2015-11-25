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
        
        let error = NSError(message: NSLocalizedString("Session expired. Please log in again.", comment: ""))
        completion(tokenInfo: nil, error: error)
        
        if let currentUser = GIDSignIn.sharedInstance().currentUser {
            currentUser.authentication.refreshTokensWithHandler { (auth, error) -> Void in
                if let error = error {
                    completion(tokenInfo: nil, error: error)
                } else if let accessToken = auth.accessToken, expirationDate = auth.accessTokenExpirationDate {
                    let tokenInfo = (accessToken: accessToken, expirationDate: expirationDate)
                    completion(tokenInfo: tokenInfo, error: nil)
                }
            }
        }
    }
}
