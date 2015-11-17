//
//  AvatarView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 14/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class AvatarView: UIView {
    
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setBorderVisible(visible: Bool) {
        layer.borderWidth = visible ? 1 : 0
    }
}

private extension AvatarView {
    
    func commonInit() {
        
        imageView.contentMode = .ScaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGRectGetHeight(frame) * 0.5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        addSubview(imageView)
        
        layer.cornerRadius = CGRectGetHeight(frame) * 0.5
        layer.borderWidth = 1
        layer.borderColor = UIColor.ngOrangeColor().CGColor
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        constrain(imageView) { imageView in
            imageView.edges == inset(imageView.superview!.edges, 1); return
        }
    }
}
