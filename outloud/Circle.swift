//
//  Circle.swift
//  outloud
//
//  Created by Ann Yuan on 6/6/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var subLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        
        self.layer.insertSublayer(subLayer, atIndex: 1)
        
        self.layer.frame = frame
        
        subLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.layer.frame.width, height: self.layer.frame.height))
        subLayer.borderWidth = 1
        subLayer.borderColor = UIColor(red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: 1.0).CGColor
        subLayer.cornerRadius = self.layer.frame.width / 2
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(size: CGFloat) {
        var center = CGFloat(self.layer.frame.width / 2 - size / 2)
        
        subLayer.frame = CGRect(origin: CGPoint(x: center, y: center), size: CGSize(width: size, height: size))
        subLayer.cornerRadius = size / 2
    }
}