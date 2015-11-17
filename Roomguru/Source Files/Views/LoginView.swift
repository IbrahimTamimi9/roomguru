//
//  LoginView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class LoginView: LaunchView {
    
    let signInButton = GPPSignInButton() as GPPSignInButton
    
    override func commonInit() {

        signInButton.style = kGPPSignInButtonStyleWide
        signInButton.colorScheme = kGPPSignInButtonColorSchemeLight
        addSubview(signInButton)
        
        super.commonInit()
    
        statusLabel.hidden = true
        showSignInButton(true)
    }
    
    override func defineConstraints() {
        super.defineConstraints()
        
        constrain(signInButton, activityIndicator) { button, indicator in
            button.center == indicator.center
        }
    }
    
    func showSignInButton(show: Bool) {
        signInButton.hidden = !show
        show ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
}
