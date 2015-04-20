//
//  AppDelegate.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 06/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, IMGSessionDelegate, PanelControllerDelegate, NSUserNotificationCenterDelegate {

    @IBOutlet weak var window: NSWindow!
    var kContextActivePanel = UnsafeMutablePointer<Void>()
    var menubarController: MenubarController?
    let clientId = "d61102426af1a52"
    
    private var _panelController: PanelController?
    var panelController: PanelController {
        if _panelController == nil {
            _panelController = PanelController(delegate: self)
            
            _panelController?.addObserver(self, forKeyPath: "_hasActivePanel", options: NSKeyValueObservingOptions.allZeros, context: kContextActivePanel)
        }
        return self._panelController!
    }
    
    //MARK: - NSApplicationDelegate 
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Uncomment following lines to reset user defaults

        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)

        if !NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedOnce")
            setupDefaults()
        }
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
                
        DirectoryManager.sharedInstance.createDirectory()
        
        DirectoryManager.sharedInstance.readDirectory(nil)
        
        IMGSession.anonymousSessionWithClientID(clientId, withDelegate: self)

        menubarController = MenubarController()
    }
    
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
    
    func applicationWillTerminate(aNotification: NSNotification) {
        self.menubarController = nil
        self.panelController.removeObserver(self, forKeyPath: "_hasActivePanel")
        
        let url: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DesktopDirectory, inDomains: .UserDomainMask).first as! NSURL
        
        DirectoryManager.sharedInstance.setScreenCaptureDefaultFolder(url)
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
            var error = params["error"] as? String
            println("Error: \(error)")
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
        self.panelController.window?.viewsNeedDisplay = true
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
    
    //MARK: - Actions
    func togglePanel(sender: AnyObject) {
        self.menubarController!.hasActiveIcon = !self.menubarController!.hasActiveIcon
        self.panelController.hasActivePanel = self.menubarController!.hasActiveIcon
    }
    
    //MARK: - Observers
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == kContextActivePanel {
            self.menubarController!.hasActiveIcon = self.panelController.hasActivePanel
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    
    //MARK: - PanelControllerDelegate
    func statusItemViewForPanelViewController() -> StatusItemView {
        return self.menubarController!.statusItemView
    }
    
    func setupDefaults() {
        let userDefaultsValuesPath: NSString
        let userDefaultsValuesDict: NSDictionary
        
        userDefaultsValuesPath = NSBundle.mainBundle().pathForResource("UserDefaults", ofType: "plist")!
        userDefaultsValuesDict = NSDictionary(contentsOfFile: userDefaultsValuesPath as String)!
        
        NSUserDefaults.standardUserDefaults().registerDefaults(userDefaultsValuesDict as [NSObject : AnyObject])
        NSUserDefaultsController.sharedUserDefaultsController().initialValues = userDefaultsValuesDict as [NSObject: AnyObject]
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }

}

