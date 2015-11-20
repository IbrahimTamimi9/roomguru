//
//  GIDProfileProvider.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import Async

enum ProfileImageDimension: UInt {
    case Small = 50
    case Medium = 100
    case Large = 150
}


struct GIDProfileProvider {
    
    static func downloadImageURLForProfile(profile: GIDProfileData, dimension: ProfileImageDimension, completion: (url: NSURL?) -> Void) {
        
        var url: NSURL?
        
        Async.background {
            url = profile.imageURLWithDimension(dimension.rawValue)
        }.main {
            completion(url: url)
        }
    }
}
