//
//  StatusItemView.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 03/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class StatusItemView: NSView {
    //MARK: - Properties
    var statusItem: NSStatusItem
    var action: Selector?
    var target: AnyObject?
    
    private var _isHighlighted: Bool = false
    var isHighlighted: Bool {
        get {
            return _isHighlighted
        }
        set {
            if _isHighlighted == newValue {
                return
            }
            _isHighlighted = newValue
            self.needsDisplay = true
        }
    }
    
    private var _image: NSImage?
    var image: NSImage? {
        get {
            return _image
        }
        set {
            if _image != newValue {
                _image = newValue
            }
            self.needsDisplay = true
        }
    }
    
    private var _alternateImage: NSImage?
    var alternateImage: NSImage? {
        get {
            return _alternateImage
        }
        set {
            if _alternateImage != newValue {
                _alternateImage = newValue
            }
            if(isHighlighted) {
                self.needsDisplay = true
            }
        }
    }
    
    var globalRect: NSRect {
        let frame: NSRect = self.frame
        return self.window!.convertRectToScreen(frame)
    }
    
    //MARK: - Initializers
    init(statusItem: NSStatusItem) {
        let itemWidth = statusItem.length
        let itemHeight = NSStatusBar.systemStatusBar().thickness
        let itemRect: NSRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight)
        
        self.statusItem = statusItem
        
        super.init(frame: itemRect)
        
        statusItem.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        var icon: NSImage?
        
        // Set up dark mode for icon
        if(NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") == "Dark") {
            icon = self.alternateImage
        } else {
            if isHighlighted {
                icon = self.alternateImage
            } else {
                icon = self.image
            }
        }
        if let icon = icon {
            let iconSize = icon.size
            let bounds = self.bounds
            let iconX = roundf(Float(NSWidth(bounds) - iconSize.width) / 2.0)
            let iconY = roundf(Float(NSHeight(bounds) - iconSize.height) / 2.0)
            let iconPoint = NSMakePoint(CGFloat(iconX), CGFloat(iconY));
            
            icon.drawAtPoint(iconPoint, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1.0)
        }
    }
    
    // #Mark: - Mouse tracking
    override func mouseDown(theEvent: NSEvent) {
        //on mouse down open panel
        if (self.action != nil) {
            NSApp.sendAction(self.action!, to: self.target, from: self)
        }
    }
}
