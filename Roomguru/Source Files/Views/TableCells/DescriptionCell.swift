//
//  DescriptionCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 30/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class DescriptionCell: UITableViewCell, Reusable {
    
    class var reuseIdentifier: String {
        return "TableViewDescriptionCellReuseIdentifier"
    }
    
    class func margins() -> (H: CGFloat, V: CGFloat) {
        return (20, 5);
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // EXPLANATION: When using cartography and autolayout
        // boundingRectWithSize:options:context: method doesn't calculate height properly.
        
        let margins = DescriptionCell.margins()
        textLabel?.frame = CGRectInset(self.bounds, margins.H, margins.V)
    }
}

private extension DescriptionCell {
    
    func commonInit() {
        
        lengthenSeparatorLine()
        
        textLabel?.numberOfLines = 0
    }
}

