//
//  AppDelegate.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 06/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, IMGSessionDelegate, NSUserNotificationCenterDelegate {

    let clientId = Keys().anonymousClientId
    
    let statusItem: NSStatusItem
    let popover: NSPopover
    var popoverMonitor: AnyObject?
    
    override init() {
        popover = NSPopover()
        popover.contentViewController = PanelViewController()
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(24)
        
        super.init()
        setupStatusButton()
    }
    
    func setupStatusButton() {
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(named: "statusItem")
            statusButton.alternateImage = NSImage(named: "statusItemHighlighted")
            
            //Hack to keep statusButton highlighted while popover is open.
            let dummyControl = DummyControl()
            dummyControl.frame = statusButton.bounds
            statusButton.addSubview(dummyControl)
            statusButton.superview!.subviews = [statusButton, dummyControl]
            dummyControl.action = "onPress:"
            dummyControl.target = self
        }
    }
    
    
    func onPress(sender: AnyObject) {
        if popover.shown == false {
            openPopover()
        }
        else {
            closePopover()
        }
    }
    
    func openPopover() {
        if let statusButton = statusItem.button {
            statusButton.highlight(true)
            popover.showRelativeToRect(NSZeroRect, ofView: statusButton, preferredEdge: NSRectEdge.MinY)
            popoverMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(.LeftMouseDownMask, handler: { (event: NSEvent!) -> Void in
                self.closePopover()
            })
        }
    }
    
    func closePopover() {
        popover.close()
        if let statusButton = statusItem.button {
            statusButton.highlight(false)
        }
        if let monitor : AnyObject = popoverMonitor {
            NSEvent.removeMonitor(monitor)
            popoverMonitor = nil
        }
    }
    
    
    //MARK: - NSApplicationDelegate 
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Uncomment following lines to reset user defaults

//        let appDomain = NSBundle.mainBundle().bundleIdentifier!
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)

        if !NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedOnce")
            setupDefaults()
        }
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
                
        DirectoryManager.sharedInstance.createDirectory()
        
        DirectoryManager.sharedInstance.readDirectory(nil)
        
        IMGSession.anonymousSessionWithClientID(clientId, withDelegate: self)
    }
    
    
    func applicationWillTerminate(aNotification: NSNotification) {
        let url: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DesktopDirectory, inDomains: .UserDomainMask).first!
        
        DirectoryManager.sharedInstance.setScreenCaptureDefaultFolder(url)
    }
    
    //MARK: - Handle URLs
    // register app to get notified when launched via URL
    func applicationWillFinishLaunching(notification: NSNotification) {
        NSAppleEventManager.sharedAppleEventManager().setEventHandler(
            self,
            andSelector: "handleURLEvent:withReply:",
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    // Gets called when the App launches/opens via URL.
    func handleURLEvent(event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
            if let url = NSURL(string: urlString) {
                handleImgurLogin(url)
            }
        }
        else {
            NSLog("No valid URL to handle")
        }
    }
    
    //MARK: - ImgurSession
    func handleImgurLogin(url: NSURL) {
        
        let params = NSMutableDictionary()
        
        for param in url.query!.componentsSeparatedByString("&") {
            let elts: NSArray = param.componentsSeparatedByString("=") as NSArray
            if elts.count < 2 {
                continue
            }
            params.setObject(elts.objectAtIndex(1) as! String, forKey: elts.objectAtIndex(0) as! String)
        }
        
        let pinCode: String? = params.objectForKey("code") as? String
        if pinCode == nil {
            let error = params["error"] as? String
            print("Error: \(error)")
        }
        
        IMGSession.sharedInstance().authenticateWithCode(pinCode)
    }

    
    //MARK: - ImgurSessionDelegate
    func imgurSessionNeedsExternalWebview(url: NSURL!, completion: (() -> Void)!) {
        NSWorkspace.sharedWorkspace().openURL(url)
    }
    
    func imgurSessionNearRateLimit(remainingRequests: Int)  {
        //TODO implement this
    }
    
    func imgurSessionModelFetched(model: AnyObject!)  {
        //TODO: - implement this
    }
    
    func imgurSessionTokenRefreshed()  {
        //TODO: - implement this
    }
    
    func imgurSessionAuthStateChanged(state: IMGAuthState) {
        if state == .Anon {
            User.sharedInstance.username = nil
            User.sharedInstance.accountID = nil
            User.sharedInstance.isLoggedIn = false
        }
    }
    
    func imgurSessionUserRefreshed(user: IMGAccount!) {
        User.sharedInstance.username = user.username
        User.sharedInstance.accountID = user.accountID
        User.sharedInstance.isLoggedIn = true
    }
    
    func imgurSessionNewNotifications(freshNotifications: [AnyObject]!) {
        //TODO: - implement this
    }
    
    func imgurRequestFailed(error: NSError!) {
        //TODO: - implement this
    }
    
    func imgurReachabilityChanged(status: AFNetworkReachabilityStatus) {
        //TODO: - implement this
    }
    
    //MARK: - Setup NSDefaults
    func setupDefaults() {
        let userDefaultsValuesPath: NSString
        let userDefaultsValuesDict: NSDictionary
        
        userDefaultsValuesPath = NSBundle.mainBundle().pathForResource("UserDefaults", ofType: "plist")!
        userDefaultsValuesDict = NSDictionary(contentsOfFile: userDefaultsValuesPath as String)!
        
        NSUserDefaults.standardUserDefaults().registerDefaults(userDefaultsValuesDict as! [String : AnyObject])
        NSUserDefaultsController.sharedUserDefaultsController().initialValues = userDefaultsValuesDict as? [String: AnyObject]
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }

}

