//
//  DummyControl.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 01/05/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class DummyControl: NSControl {
    override func mouseDown(theEvent: NSEvent) {
        superview!.mouseDown(theEvent)
        sendAction(action, to: target)
    }
}
