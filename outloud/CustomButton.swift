//
//  CustomButton.swift
//  outloud
//
//  Created by Ann Yuan on 5/6/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func drawRect(rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        layer.masksToBounds = true
        layer.cornerRadius = 16.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGrayColor().CGColor
        
        setTitleColor(UIColor.grayColor(), forState:UIControlState.Normal)
        contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15)
        
        if let superview = superview {
            superview.clipsToBounds = false
        }
        
    }

}
