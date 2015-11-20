//
//  UserDiskManager.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class UserDiskManager {
    
    private let directoryName = "Profile"
    var profileDirectoryPath: String { return directoryPath() }
    
    init() {
        createDirectoryIfNeeded()
    }
    
    func deleteProfileImageWithIdentifier(identifier: String) {
        let destinationURL = NSURL(fileURLWithPath: pathForIdentifier(identifier))
        try! NSFileManager.defaultManager().removeItemAtURL(destinationURL)
    }
    
    func loadProfileImageWithIdentifier(identifier: String) -> NSData? {
        
        return NSData(contentsOfFile: pathForIdentifier(identifier))
    }
    
    func saveProfileImage(temporaryLocation: NSURL, forIdentifier identifier: String) {
        
        let destinationURL = NSURL(fileURLWithPath: pathForIdentifier(identifier))
        do {
            try NSFileManager.defaultManager().moveItemAtURL(temporaryLocation, toURL: destinationURL)
        } catch {
            return
        }
        
        // remove
        // Fixme: Probably not the best implementation, any ideas?
        let _ = try? NSFileManager.defaultManager().removeItemAtURL(temporaryLocation)
    }
    
    func existFileWithIdentifier(identifier: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(pathForIdentifier(identifier))
    }
}

private extension UserDiskManager {
    
    func createDirectoryIfNeeded() {
        let path = directoryPath()
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
            try! NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    func directoryPath() -> String {
        let documentsDirectory: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return documentsDirectory.stringByAppendingPathComponent(directoryName)
    }
    
    func pathForIdentifier(identifier: String) -> String {
        return directoryPath().stringByAppendingFormat("/%@", identifier)
    }
}
