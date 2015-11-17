//
//  BookingConfirmationView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography
import FontAwesome_swift

class BookingConfirmationView: UIView {

    let minutesToBookLabel = UILabel()
    
    private(set) var confirmButton = UIButton(type: .System)
    private(set) var cancelButton = UIButton(type: .System)
    
    private(set) var lessMinutesButton = UIButton(type: .System)
    private(set) var moreMinutesButton = UIButton(type: .System)
    
    let summaryTextField = InsetTextField()
    
    private let minutesShortLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension BookingConfirmationView {
    
    func markErrorOnSummaryTextField() {
        updateAccessoryLabelWithFontAwesome(.ExclamationCircle, color: .ngRedColor())
    }
    
    func removeErrorFromSummaryTextField() {
        updateAccessoryLabelWithFontAwesome(.CheckCircle, color: .ngGreenColor())
    }
    
    private func updateAccessoryLabelWithFontAwesome(fontAwesome: FontAwesome, color: UIColor) {
        if let label = summaryTextField.leftView as? UILabel {
            label.text = .fontAwesomeIconWithName(fontAwesome)
            label.textColor = color
        }
    }
}

private extension BookingConfirmationView {
    
    func commonInit() {
        backgroundColor = .whiteColor()
        
        summaryTextField.leftView = UILabel.roundedExclamationMarkLabel(CGRectMake(0, 0, 30, 30))
        summaryTextField.leftViewMode = .Always
        markErrorOnSummaryTextField()
        
        configureButtonsAppearance()
        configureLabelsAppearance()
        configureTextFieldAppearance()
        
        addSubview(confirmButton)
        addSubview(cancelButton)
        addSubview(lessMinutesButton)
        addSubview(moreMinutesButton)
        
        addSubview(minutesToBookLabel)
        addSubview(minutesShortLabel)
        
        addSubview(summaryTextField)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        constrain(cancelButton, confirmButton) { cancel, confirm in
            cancel.left == cancel.superview!.left + 10
            cancel.bottom == cancel.superview!.bottom - 10
            
            confirm.right == cancel.superview!.right - 10
            confirm.bottom == cancel.superview!.bottom - 10
            
            cancel.right == confirm.left - 10
            
            cancel.height == 40
            cancel.width == confirm.width
            confirm.height == cancel.height
        }
        
        constrain(minutesToBookLabel, minutesShortLabel) { book, short in
            book.center == book.superview!.center
            book.width == 70
            book.height == 50
            
            short.width == book.width
            short.centerX == book.centerX
            short.top == book.bottom
        }
        
        constrain(lessMinutesButton, minutesToBookLabel) { button, book in
            button.width == 44
            button.height == 44
            button.centerY == button.superview!.centerY
            button.right == book.left
        }
        
        constrain(moreMinutesButton, minutesToBookLabel) { button, book in
            button.width == 44
            button.height == 44
            button.centerY == button.superview!.centerY
            button.left == book.right
        }
        
        constrain(summaryTextField) { textField in
            textField.top == textField.superview!.top + 54
            textField.left == textField.superview!.left + 10
            textField.right == textField.superview!.right - 10
            textField.height == 30
            return
        }
    }
    
    func configureButtonsAppearance() {
        setupButton(&lessMinutesButton, withFontAwesome: .ArrowLeft)
        setupButton(&moreMinutesButton, withFontAwesome: .ArrowRight)
        
        setupRoundButton(&confirmButton, withTitle: NSLocalizedString("Book", comment: ""), color: .ngOrangeColor())
        setupRoundButton(&cancelButton, withTitle: NSLocalizedString("Cancel", comment: ""), color: .ngRedColor())
    }
    
    func setupButton(inout button: UIButton, withFontAwesome fontAwesome: FontAwesome) {
        button.titleLabel?.font = .fontAwesomeOfSize(16)
        button.setTitle(String.fontAwesomeIconWithName(fontAwesome))
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)

    }
    
    func setupRoundButton(inout button: UIButton, withTitle title: String, color: UIColor) {
        button.setTitle(title)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 5.0
    }
    
    func configureLabelsAppearance() {
        minutesShortLabel.text = NSLocalizedString("minutes", comment: "")
        minutesShortLabel.numberOfLines = 1
        minutesShortLabel.adjustsFontSizeToFitWidth = true
        minutesShortLabel.textAlignment = .Center
        
        minutesToBookLabel.font = UIFont.boldSystemFontOfSize(28.0)
        minutesToBookLabel.textAlignment = .Center
    }
    
    func configureTextFieldAppearance() {
        summaryTextField.placeholder = NSLocalizedString("Summary (min. 5 characters)", comment: "")
        summaryTextField.borderStyle = .RoundedRect
        summaryTextField.leftInset = 30
    }
}
