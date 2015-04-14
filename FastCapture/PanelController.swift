//
//  PanelController.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 03/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa
import CoreGraphics

protocol PanelControllerDelegate {
    func statusItemViewForPanelViewController() -> StatusItemView
}

class PanelController: NSWindowController, NSWindowDelegate, ScreenCaptureDelegate {
    let OPEN_DURATION = 0.15
    let CLOSE_DURATION = 0.1
    
    let MENU_ANIMATION_DURATION = 0.1
    
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var userLogoImage: NSImageView!
    @IBOutlet weak var lastScreenCapture: NSImageView!
    @IBOutlet weak var lastScreenCaptureLabel: NSTextField!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var copyLastCaptureToClipboardButton: NSButton!
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet var settingsMenu: NSMenu!
    @IBOutlet weak var takeFirstScreenCaptureLabel: NSTextField!
    var delegate: PanelControllerDelegate?
    
    var lastScreenCaptureURL: NSURL?
    
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
        panel.becomeKeyWindow()
        panel.floatingPanel = true
        panel.level = kCGMaximumWindowLevelKey
        panel.opaque = false
        panel.worksWhenModal = true
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
            panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - arrowHeight)
        }
        
        var statusX = roundf(Float(NSMidX(statusRect)));
        var panelX = CGFloat(statusX) - NSMinX(panelRect);
        
        self.backgroundView!.arrowX = Int(panelX);
        
        panel.alphaValue = 0
        panel.setFrame(NSRect(x: panelRect.minX, y: panelRect.maxY, width: panelRect.width, height: 0), display: true)
        panel.makeKeyAndOrderFront(self)
        
        setupView()
        
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
    
    //MARK: - ScreenCaptureDelegate
    func addLastScreenCaptureURL(fileURL: NSURL) {
        lastScreenCaptureURL = fileURL
        setupView()
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
    
    @IBAction func login(sender: NSButton) {
        User.sharedInstance.login()
    }
    
    func setupView () {
        var fileURL: NSURL? = lastScreenCaptureURL
        
        if fileURL == nil {
            fileURL = NSUserDefaults.standardUserDefaults().URLForKey("lastCapture")
            
            if fileURL == nil {
                lastScreenCaptureLabel!.stringValue = ""
                lastScreenCapture.hidden = true
                
                copyLastCaptureToClipboardButton.hidden = true
                
                takeFirstScreenCaptureLabel.hidden = false
                return
            }
        }
        
        takeFirstScreenCaptureLabel.hidden = true
        lastScreenCapture.hidden = false
        copyLastCaptureToClipboardButton.hidden = false
        
        lastScreenCaptureLabel!.stringValue = "Last uploaded: \(fileURL!.description)"
    
        let urlRequest = NSURLRequest(URL: fileURL!)
        var requestOperation = AFHTTPRequestOperation(request: urlRequest)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        
        requestOperation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            self.lastScreenCapture.image = responseObject as? NSImage
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        })
        
        requestOperation.start()
    }
}