//
//  GoogleCalendarService.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 23/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct GoogleCalendarService: SecureNetworkService {
    let host = Constants.Google.ServerURL
    
    func authorizeRequest(request: NSMutableURLRequest) {
        if let currentUser = GIDSignIn.sharedInstance().currentUser {
            request.setValue("Bearer " + currentUser.authentication.accessToken, forHTTPHeaderField: "Authorization")
        }
    }
}
