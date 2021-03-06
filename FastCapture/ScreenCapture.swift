//
//  ScreenCapture.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 05/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

protocol ScreenCaptureDelegate {
    func addLastScreenCaptureURL(fileURL: NSURL) //TODO: - change name and behaviour
    func uploadingScreenCaptureProgress()
}

private let _ScreenCaptureInstance = ScreenCapture()

class ScreenCapture: NSObject {
    class var sharedInstance: ScreenCapture {
        return _ScreenCaptureInstance
    }
    
    var events: CDEvents?
    //TODO: - change path, use NSDefaults
    var url: NSURL?
    var cache = NSMutableDictionary()
    var enumerator: NSDirectoryEnumerator?
    var delegate: ScreenCaptureDelegate?
    
    var _notification: NSUserNotification?
    var notification: NSUserNotification {
        get {
            if _notification == nil {
                _notification = NSUserNotification()
                _notification!.title = "FastCapture"
                _notification!.informativeText = "A link to your screenshot has been copied to your clipboard."
                _notification!.soundName = NSUserNotificationDefaultSoundName
            }
            return _notification!
        }
    }
    
    func run() {
        let urlsWatched: [AnyObject] = NSArray(object: DirectoryManager.sharedInstance.url!) as [AnyObject]
        let runLoop: NSRunLoop = NSRunLoop.currentRunLoop()
        
        let block: CDEventsEventBlock? = { (let watcher: CDEvents!,  event: CDEvent!) -> Void in
            DirectoryManager.sharedInstance.readDirectory({(fileURL: NSURL) in
                //TODO: - uncomment following line, check connectivity
                self.uploadImage(fileURL)
                })
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            NSRunLoop.currentRunLoop().run()

            self.events = CDEvents(URLs: urlsWatched, block: block, onRunLoop: runLoop, sinceEventIdentifier: kCDEventsSinceEventNow, notificationLantency: 0, ignoreEventsFromSubDirs: true, excludeURLs: [], streamCreationFlags: kCDEventsDefaultEventStreamFlags)
        }
    }
    
    func uploadImage(fileURL: NSURL) {
        //TODO: - upload to specified album, NSDefault shouldbe: FastCapture. User can change this.
        //TODO: - add progress bar on PanelViewController
        IMGImageRequest.uploadImageWithFileURL(fileURL, success: {(imgImage: IMGImage!) -> Void in
            NSUserDefaults.standardUserDefaults().setURL(imgImage.url, forKey: "lastCapture")
            self.delegate?.addLastScreenCaptureURL(imgImage.url)
            
            NSPasteboard.generalPasteboard().clearContents()
            NSPasteboard.generalPasteboard().setString(imgImage.url.description, forType: NSStringPboardType)
            
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
            
            //TODO: - set the url on the PanelController, remove the progress bar, download this image
            }, progress: nil, failure: { (error: NSError!) -> Void in
                print("Error: \(error)")

                let alert = NSAlert()
                alert.messageText = error.description
                alert.runModal()
            })
    }
    
    func addNewFilesToCache(contents: NSArray?, cb: ((fileURL: NSURL) -> Void)?) {
        let predicate = NSPredicate(format: "pathExtension == 'png'", argumentArray: nil)
        for fileURL in contents!.filteredArrayUsingPredicate(predicate) {
            var name: AnyObject?
            
            do {
                try (fileURL as! NSURL).getResourceValue(&name, forKey: NSURLNameKey)

            }
            catch let error as NSError {
                //TODO: check if there was any error. return if it does
                print("Error: \(error.domain)")
            }
            
            
            let key = name! as! String
            let object: NSURL? = cache.objectForKey(key) as? NSURL
            
            if object == nil {
                self.cache.setObject(fileURL, forKey: key)
                if(cb != nil) {
                    cb!(fileURL: fileURL as! NSURL)
                }
            }
        }
    }
}
