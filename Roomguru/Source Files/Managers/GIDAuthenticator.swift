//
//  GIDAuthenticator.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

final class GIDAuthenticator: NSObject {
    
    typealias AuthenticatorCompletionBlock = (authenticated: Bool, authenticatedUser: GIDGoogleUser? ,error: NSError?) -> Void

    static var isUserAuthenticated: Bool {
        return GIDSignIn.sharedInstance().currentUser != nil
    }
    
    private let presentingViewController: UIViewController?
    private let completion: AuthenticatorCompletionBlock
    private(set) var isAuthenticating = false
    private var expirationDate: NSDate?
    
    init(presentingViewController: UIViewController?, completion: AuthenticatorCompletionBlock) {
        
        self.presentingViewController = presentingViewController
        self.completion = completion

        super.init()
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        let sharedSignIn = GIDSignIn.sharedInstance();
        sharedSignIn.delegate = self
        sharedSignIn.uiDelegate = self
    }
    
    func startAuthentication() {
        
        isAuthenticating = true
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
            
        } else {
            Async.main(after: 0.2) {
                self.completion(authenticated: false, authenticatedUser: nil, error: nil)
            }
        }
    }
    
    func handleURL(url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        isAuthenticating = true
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        NetworkManager.sharedInstance.enableTokenStore(false)
    }
}

 // MARK: GIDSignInDelegate Methods

extension GIDAuthenticator: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn?, didSignInForUser user: GIDGoogleUser?, withError error: NSError?) {
        
        isAuthenticating = false
        
        if let error = error {
            completion(authenticated: false, authenticatedUser: nil, error: error)
        } else {
            completion(authenticated: true, authenticatedUser: user, error: nil)
        }
    }
    
    func signIn(signIn: GIDSignIn?, didDisconnectWithUser user: GIDGoogleUser?, withError error: NSError?) {
        isAuthenticating = false
        completion(authenticated: false, authenticatedUser: nil, error: error)
    }
}

// MARK: GIDSignInUIDelegate Methods

extension GIDAuthenticator: GIDSignInUIDelegate {
   
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        presentingViewController?.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        viewController .dismissViewControllerAnimated(true, completion: nil)
    }
}
