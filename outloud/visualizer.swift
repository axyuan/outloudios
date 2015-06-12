//
//  visualizer.swift
//  outloud
//
//  Created by Ann Yuan on 6/2/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import Foundation
import UIKit

class GameLoop : NSObject {
    
    var viewController : UIViewController
    var displayLink : CADisplayLink!
    var frameInterval : Int!
    var minPower = -160.0
    var maxPower = 0.0
    var minRadius = 150.0
    var maxRadius = 200.0
    
    init(frameInterval: Int, view: UIViewController) {
        self.frameInterval = frameInterval
        self.viewController = view
        super.init()
    }
    
    func handleTimer() {
        var viewCOn = self.viewController as! ViewController
        var power = Double(viewCOn.audioRecorder.averagePowerForChannel(1))
        var newRadius = minRadius + ((power - minPower) / (maxPower - minPower)) * (maxRadius - minRadius)
        
        viewCOn.circleView.draw(CGFloat(newRadius))
    }
    
    func start() {
        displayLink = CADisplayLink(target: self, selector: Selector("handleTimer"))
        displayLink.frameInterval = frameInterval
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func stop() {
        displayLink.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink.invalidate()
        displayLink = nil
    }
}