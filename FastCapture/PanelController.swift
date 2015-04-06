//
//  PanelController.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 03/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

protocol PanelControllerDelegate {
    func statusItemViewForPanelViewController() -> StatusItemView
}

class PanelController: NSWindowController, NSWindowDelegate, ScreenCaptureDelegate {
    let OPEN_DURATION = 0.15
    let CLOSE_DURATION = 0.1
    
    let POPUP_HEIGHT = 330
    let PANEL_WIDTH  = 310
    let MENU_ANIMATION_DURATION = 0.1
    
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var userLogoImage: NSImageView!
    @IBOutlet weak var lastScreenCapture: NSImageView!
    @IBOutlet weak var lastScreenCaptureLabel: NSTextField!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var copyToClipboardButton: NSButton!
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet var settingsMenu: NSMenu!
    
    var delegate: PanelControllerDelegate?
    
    private var _hasActivePanel: Bool = false
    var hasActivePanel: Bool {
        get {
            return _hasActivePanel
        }
        set {
            if _hasActivePanel != newValue {
                _hasActivePanel = newValue
                
                if _hasActivePanel {
                    openPanel()
                }
                else {
                    closePanel()
                }
            }
        }
    }
    
    convenience init(delegate: PanelControllerDelegate) {
        self.init(windowNibName: "Panel")
        self.delegate = delegate
        ScreenCapture.sharedInstance.delegate = self
    }
    
    override func awakeFromNib()  {
        super.awakeFromNib()
        
        var panel: NSPanel = self.window as! NSPanel
        panel.acceptsMouseMovedEvents = true
        panel.level = Int(CGWindowLevelKey(Int32(kCGPopUpMenuWindowLevelKey)))
        panel.opaque = false
        panel.backgroundColor = NSColor.clearColor()
    }
    
    func openPanel() {
        let panel: NSPanel = self.window as! NSPanel
        
        let statusRect: NSRect = self.statusRectForWindow(panel)
        let screenRect = (NSScreen.screens()?.first as! NSScreen).frame
        
        var panelRect = panel.frame as NSRect
        panelRect.origin.x = CGFloat(roundf(Float(NSMidX(statusRect) - NSWidth(panelRect) / 2)))
        panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
        
        let arrowHeight = CGFloat(Float(ARROW_HEIGHT))
        if (NSMaxX(panelRect) > (NSMaxX(screenRect) - arrowHeight)) {
            println("entrei")
            panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - arrowHeight)
        }
        
        var statusX = roundf(Float(NSMidX(statusRect)));
        var panelX = CGFloat(statusX) - NSMinX(panelRect);
        
        self.backgroundView!.arrowX = Int(panelX);

        NSApp.activateIgnoringOtherApps(false)
        panel.alphaValue = 0
        panel.setFrame(statusRect, display: false)
        panel.makeKeyAndOrderFront(self)
        
        let openDuration: NSTimeInterval = OPEN_DURATION
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = openDuration
        panel.animator().setFrame(panelRect, display: true)
        panel.animator().alphaValue = 1
        NSAnimationContext.endGrouping()
    }
    
    func closePanel() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = CLOSE_DURATION
        self.window!.animator().alphaValue = 0
        NSAnimationContext.endGrouping()
        
        let time = Int64(UInt64(NSEC_PER_SEC) * UInt64(CLOSE_DURATION) * UInt64(2))

        dispatch_after(dispatch_walltime(nil, time), dispatch_get_main_queue(), {
            self.window!.orderOut(nil)
            })
    }
    
    func statusRectForWindow(panel: NSPanel) -> NSRect {
        let screenRect = (NSScreen.screens()?.first as! NSScreen).frame
        var statusRect = NSZeroRect
        
        var statusItemView: StatusItemView?
        
        if (delegate != nil) {
            statusItemView = delegate!.statusItemViewForPanelViewController()
        }
        
        if (statusItemView != nil) {
            statusRect = statusItemView!.globalRect
            statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
        } else {
            statusRect.size = NSMakeSize(CGFloat(STATUS_ITEM_VIEW_WIDTH), NSStatusBar.systemStatusBar().thickness);
            statusRect.origin.x  = CGFloat(roundf(Float(NSWidth(screenRect) - NSWidth(statusRect)) / 2.0))
            statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;

        }
        return statusRect
    }
    
    //MARK: - NSWindowDelegate
    func windowWillClose(notification: NSNotification) {
        hasActivePanel = false
    }
    
    func windowDidResignKey(notification: NSNotification) {
        if self.window!.visible {
            hasActivePanel = false
        }
    }
    
//    func windowDidResize(notification: NSNotification) {
//        let panel: NSPanel = self.window as! NSPanel
//        let statusRect: NSRect = self.statusRectForWindow(panel)
//        let panelRect = panel.frame
//        
//        var statusX = roundf(Float(NSMidX(statusRect)));
//        var panelX = CGFloat(statusX) - NSMinX(panelRect);
//        
//        self.backgroundView!.arrowX = Int(panelX);
//        
//        //TODO: - resize elements
//    }
//    
    //MARK: - ScreenCaptureDelegate
    
    func addLastScreenCaptureURL(fileURL: NSURL) {
        lastScreenCaptureLabel!.stringValue = "Last uploaded: \(fileURL)"
        
        //TODO: - download image from imgur
    }
    
    func uploadingScreenCaptureProgress() {
        
    }
    
    //MARK: - UI Actions
    @IBAction func settingsButtonAction(sender: NSButton) {
        NSMenu.popUpContextMenu(settingsMenu!, withEvent: NSApp.currentEvent!!, forView: sender)
    }
    @IBAction func copyLastCaptureToClipboard(sender: NSButton) {
        let fileURL = NSUserDefaults.standardUserDefaults().URLForKey("lastCapture")
        
        if let urlDescription = fileURL?.description  {
            NSPasteboard.generalPasteboard().clearContents()
            NSPasteboard.generalPasteboard().setString(urlDescription, forType: NSStringPboardType)
        }
    }
}