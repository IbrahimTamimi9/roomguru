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
    
    func refreshAccessToken(completion: (didRefresh: Bool, error: NSError?)-> Void) {
        
        if let currentUser = GIDSignIn.sharedInstance().currentUser {
            currentUser.authentication.refreshTokensWithHandler { (auth, error) -> Void in
                if let error = error {
                    completion(didRefresh: false, error: error)
                } else if let _ = auth.accessToken, _ = auth.accessTokenExpirationDate {
                    completion(didRefresh: true, error: nil)
                }
            }
        } else {
            let error = NSError(message: NSLocalizedString("Session expired. Please log in again.", comment: ""))
            completion(didRefresh: false, error: error)
        }
    }
}
