//
//  SecureNetworkService.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 21/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol SecureNetworkService: NetworkService {}

extension SecureNetworkService {
    /// Use https scheme as default for secure network service
    var scheme: String {
         return "https"
    }
}
