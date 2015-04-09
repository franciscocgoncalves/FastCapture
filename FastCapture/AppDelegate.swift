//
//  AppDelegate.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 06/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, IMGSessionDelegate, PanelControllerDelegate {

    @IBOutlet weak var window: NSWindow!
    var kContextActivePanel = UnsafeMutablePointer<()>()
    var menubarController: MenubarController?
    let clientId = "1827bb4a1bbb753"
    
    private var _panelController: PanelController?
    var panelController: PanelController {
        if self._panelController == nil {
            self._panelController = PanelController(delegate: self)
        }
        return self._panelController!
    }
    
    //MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Uncomment following lines to reset user defaults

        //let appDomain = NSBundle.mainBundle().bundleIdentifier!
        //NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)

        if !NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedOnce")
            setupDefaults()
        }
                
        ScreenCapture.sharedInstance.createDirectory()
        
        ScreenCapture.sharedInstance.readDirectory(nil)
        
        menubarController = MenubarController()
        
        IMGSession.anonymousSessionWithClientID(clientId, withDelegate: self)
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        self.menubarController = nil
    }
    
    //MARK: - ImgurSession
    func application(application: NSApplication, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        
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
            return false
        }
        
        IMGSession.sharedInstance().authenticateWithCode(pinCode)
        
        return true
    }
    
    //MARK: - ImgurSessionDelegate
    func imgurSessionNeedsExternalWebview(url: NSURL!, completion: (() -> Void)!) {
        println("URL: \(url)")
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
        //TODO: - implement this
    }
    
    func imgurSessionUserRefreshed(user: IMGAccount!) {
        //TODO: - implement this
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

}

