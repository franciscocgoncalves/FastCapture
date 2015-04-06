//
//  MenubarController.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 03/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa


class MenubarController: NSObject {
    var statusItemView: StatusItemView
    var statusItem: NSStatusItem {
        return self.statusItemView.statusItem
    }
    private var _hasActiveIcon: Bool = false
    var hasActiveIcon: Bool {
        get {
            return _hasActiveIcon
        }
        set {
            if(_hasActiveIcon != newValue) {
                _hasActiveIcon = newValue
                statusItemView.isHighlighted = newValue
            }
        }
    }
    
    override init()  {
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(CGFloat(STATUS_ITEM_VIEW_WIDTH))
        statusItemView = StatusItemView(statusItem: statusItem)
        statusItemView.image = NSImage(named: "statusImage")
        statusItemView.alternateImage = NSImage(named: "statusHighlighted")
        statusItemView.action = Selector("togglePanel:")
        super.init()
        
        ScreenCapture.sharedInstance.run()
    }
}
