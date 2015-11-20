//
//  LoginViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController  {

    private weak var aView: LoginView?

    // MARK: Lifecycle

    override func loadView() {
        aView = loadViewWithClass(LoginView.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Login", comment: "")
        aView?.avatarView.imageView.image = UserPersistenceStore.sharedStore.userImage()
        aView?.signInButton.addTarget(self, action: Selector("didTapSignInButton:"), forControlEvents: .TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let shouldShowSignInButton = !GIDAuthenticator.isUserAuthenticated || UserPersistenceStore.sharedStore.user == nil
        aView?.showSignInButton(shouldShowSignInButton)
        aView?.avatarView.imageView.image = UserPersistenceStore.sharedStore.userImage()
    }
    
    // MARK: Public
    
    func pushCalendarPickerViewController(completion: VoidBlock?) {
        aView?.avatarView.imageView.image = UserPersistenceStore.sharedStore.userImage()
        
        let calendarPickerViewController = CalendarPickerViewController()
        calendarPickerViewController.saveCompletionBlock = completion
        calendarPickerViewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(calendarPickerViewController, animated: true)
    }
    
    func showError(error: NSError) {
        aView?.showSignInButton(true)
        
        self.presentViewController(UIAlertController(error: error), animated: true, completion: nil)
    }
    
    func didTapSignInButton(sender: GIDSignInButton) {
        aView?.showSignInButton(false)
    }
}
