//
//  NetworkService.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 21/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol NetworkService {
    var host: String { get }
    var scheme: String { get }
    var serviceType: NSURLRequestNetworkServiceType { get }
    
    func authorizeRequest(request: NSMutableURLRequest)
}

extension NetworkService {
    /// Network service has network service type as default
    var serviceType: NSURLRequestNetworkServiceType {
        return .NetworkServiceTypeDefault
    }
}
