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
    
    var doSomething: (vc : ViewController?) -> ()
    var displayLink : CADisplayLink!
    var frameInterval : Int!
    
    init(frameInterval: Int, doSomething: (vc : ViewController?) -> ()) {
        self.doSomething = {doSomething(vc : $0)}
        self.frameInterval = frameInterval
        super.init()
    }
    
    func handleTimer(vc : ViewController) {
        doSomething(vc: ViewController())
    }
    
    func start() {
        displayLink = CADisplayLink(target: self, selector: Selector("handleTimer:"))
        displayLink.frameInterval = frameInterval
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func stop() {
        displayLink.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink.invalidate()
        displayLink = nil
    }
}