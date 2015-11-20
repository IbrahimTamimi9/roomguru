//
//  GIDTokenStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 31/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

final class GIDTokenStore {
    
    private var auth: GIDAuthentication
    
    var tokenExpirationDate: NSDate {
        return auth.accessTokenExpirationDate
    }
    
    var accessToken: String {
        return auth.accessToken
    }
    
    var networkCoordinator = GIDTokenStoreNetworkCoordinator()
    
    init(auth: GIDAuthentication) {
        self.auth = auth
    }
        
    func refreshTokenIfNeeded(id id: String, completion: ((didRefresh: Bool, error: NSError?) -> Void)) {
        
        // NGRTemp: Temporary workaround - it'll be enhanced in the future
        let isTokenValid = true
        if isTokenValid {
            completion(didRefresh: false, error: nil)
            return
        }
    }
}
