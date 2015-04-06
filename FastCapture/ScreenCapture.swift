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
    let url = NSURL(fileURLWithPath: "/Users/franciscogoncalves/Dropbox/Capturas de tela")
    var cache = NSMutableDictionary()
    var enumerator: NSDirectoryEnumerator?
    var delegate: ScreenCaptureDelegate?
    
    convenience init(delegate: ScreenCaptureDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func run() {
        let urlsWatched: [AnyObject] = NSArray(object: url!) as [AnyObject]
        let creationFlags = kCDEventsDefaultEventStreamFlags;
        let runLoop: NSRunLoop = NSRunLoop.currentRunLoop()
        
        var block: CDEventsEventBlock? = { (var watcher: CDEvents!, var event: CDEvent!) -> Void in
            println("got event")
            self.readDirectory({(fileURL: NSURL) in
                //TODO: - uncomment following line, check connectivity
                self.uploadImage(fileURL)
                NSPasteboard.generalPasteboard().clearContents()
                NSPasteboard.generalPasteboard().setString(fileURL.description, forType: NSStringPboardType)
                })
        }
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)) {
            NSRunLoop.currentRunLoop().run()

            self.events = CDEvents(URLs: urlsWatched, block: block, onRunLoop: runLoop, sinceEventIdentifier: kCDEventsSinceEventNow, notificationLantency: 0, ignoreEventsFromSubDirs: true, excludeURLs: [], streamCreationFlags: kCDEventsDefaultEventStreamFlags)
        }
    }
    
    func uploadImage(fileURL: NSURL) {
        //TODO: - upload to specified album, NSDefault shouldbe: FastCapture. User can change this.
        //TODO: - add progress bar on PanelViewController
        IMGImageRequest.uploadImageWithFileURL(fileURL, success: {(imgImage: IMGImage!) -> Void in
            println(imgImage.url)
            NSUserDefaults.standardUserDefaults().setURL(imgImage.url, forKey: "lastCapture")
            self.delegate?.addLastScreenCaptureURL(fileURL)
            //TODO: - add notification to user.
            //TODO: - set the url on the PanelController, remove the progress bar, download this image
            }, progress: nil, failure: { (error: NSError!) -> Void in
                println("Error: \(error)")
            })
    }
    
    func readDirectory(cb: ((fileURL: NSURL) -> Void)?) {
        println("starting")
        let fileManager = NSFileManager.defaultManager()
        let keys = NSArray(objects: NSURLNameKey)
        let options = (NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants | NSDirectoryEnumerationOptions.SkipsHiddenFiles)
        var error: NSError?
        
        //Get Contents of directory
        let contents: NSArray? = fileManager.contentsOfDirectoryAtURL(self.url!, includingPropertiesForKeys: keys as [AnyObject], options: options, error: &error)
        
        addNewFilesToCache(contents, cb: cb)
    }
    
    func addNewFilesToCache(contents: NSArray?, cb: ((fileURL: NSURL) -> Void)?) {
        let predicate = NSPredicate(format: "pathExtension == 'png'", argumentArray: nil)
        for fileURL in contents!.filteredArrayUsingPredicate(predicate) {
            var name: AnyObject?
            var error: NSError?
            fileURL.getResourceValue(&name, forKey: NSURLNameKey, error: &error)
            //TODO:  check if there was any error. return if it does
            
            var key = name! as! String
            var object: NSURL? = cache.objectForKey(key) as? NSURL
            
            if object == nil {
                println(name)
                self.cache.setObject(fileURL, forKey: key)
                if(cb != nil) {
                    cb!(fileURL: fileURL as! NSURL)
                }
            }
        }
    }
}
