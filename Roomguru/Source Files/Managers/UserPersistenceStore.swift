//
//  UserPersistenceStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import CryptoSwift

private protocol Persistence {
    
    func save()
    func clear() -> Bool
    func load() -> User?
}

final class UserPersistenceStore {
    
    class var sharedStore: UserPersistenceStore {
        struct Static {
            static let instance: UserPersistenceStore = UserPersistenceStore()
        }
        return Static.instance
    }
    
    private let size: Int = 150
    private let downloader = UserImageDownloader()
    private let diskManager = UserDiskManager()
    
    private(set) var user: User?

    init() {
        self.user = load()
    }
    
    func registerGoogleUser(googleUser: GIDGoogleUser) {

        //do nothing if already exists
        if let user = user where user.email == googleUser.profile.email {
            downloadProfileImageIfNeccessaryForGoogleUser(googleUser)
            return
        }
        
        clear()
        user = User(email: googleUser.profile.email)
        save()
        downloadProfileImageIfNeccessaryForGoogleUser(googleUser)
    }
    
    func userImage() -> UIImage? {
        if let id = hash(), data = diskManager.loadProfileImageWithIdentifier(id), image = UIImage(data: data) {
            return image
        }
        return UIImage(named: "placeholder")
    }
}

// MARK: Private

private extension UserPersistenceStore {
    
    func downloadProfileImageIfNeccessaryForGoogleUser(user: GIDGoogleUser) {
        
        if !shouldDownloadImage() {
            return
        }
        
        GIDProfileProvider.downloadImageURLForProfile(user.profile, dimension: ProfileImageDimension.Large) { url in
            if let url = url {
                self.downloadImageFromURL(url)
            }
        }
    }
    
    func shouldDownloadImage() -> Bool {
        if let id = hash() {
            return !self.diskManager.existFileWithIdentifier(id)
        }
        return true
    }
    
    func downloadImageFromURL(url: NSURL) {
        
        self.downloader.downloadFileFromURL(url) { (locationURL) -> Void in
            
            if let locationURL = locationURL, id = self.hash() {
                self.diskManager.saveProfileImage(locationURL, forIdentifier: id)
            }
        }
    }
    
    func hash() -> String? {
        return user?.email.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).md5()
    }
}

// MARK: Persistance

extension UserPersistenceStore: Persistence {
    
    func save() {
        if let user = user {
            Defaults[User.key] = NSKeyedArchiver.archivedDataWithRootObject(user)
            Defaults.synchronize()
        }        
    }
    
    func clear() -> Bool {
        if Defaults.hasKey(User.key) {
            Defaults.remove(User.key)
            Defaults.synchronize()
            user = nil
            return true
        }
        return false
    }
    
    func load() -> User? {
        if let data = Defaults[User.key].data {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
        }
        return nil
    }
}
