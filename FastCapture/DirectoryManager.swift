//
//  DirectoryManager.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 20/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

private let _DirectoryManager = DirectoryManager()

class DirectoryManager: NSObject {
    class var sharedInstance: DirectoryManager {
        return _DirectoryManager
    }
    
    var url: NSURL?
    
    func createDirectory() {
        let userDefaultURL: AnyObject? = NSUserDefaults.standardUserDefaults().URLForKey("screenCaptureDirectory")
        let folderDestinationURL: NSURL
        
        if userDefaultURL == nil {
            if let picturesURL = NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask).first as? NSURL {
                folderDestinationURL = picturesURL.URLByAppendingPathComponent("ScreenCapture")
            }
            else {
                //should alert user
                return
            }
        }
        else {
            folderDestinationURL = userDefaultURL as! NSURL
        }
        
        var err: NSErrorPointer = nil
        var isDir = ObjCBool(true)
        if !NSFileManager.defaultManager().fileExistsAtPath(folderDestinationURL.path!, isDirectory: &isDir) {
            if NSFileManager.defaultManager().createDirectoryAtPath(folderDestinationURL.path!, withIntermediateDirectories: true, attributes: nil, error: err) {
                println("sucessfuly created dir")
            } else {
                println("failed creating dir: \(err)")
                //should alert user
                return
            }
        }

        setDirectory(folderDestinationURL)
    }
    
    func readDirectory(cb: ((fileURL: NSURL) -> Void)?) {
        let fileManager = NSFileManager.defaultManager()
        let keys = NSArray(objects: NSURLNameKey)
        let options = (NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants | NSDirectoryEnumerationOptions.SkipsHiddenFiles)
        var error: NSError?
        
        //Get Contents of directory
        if(self.url == nil) {
            self.url = NSUserDefaults.standardUserDefaults().URLForKey("screenCaptureDirectory")
            
        }
        let contents: NSArray? = fileManager.contentsOfDirectoryAtURL(self.url!, includingPropertiesForKeys: keys as? [AnyObject], options: options, error: &error)
        
        ScreenCapture.sharedInstance.addNewFilesToCache(contents, cb: cb)
    }
    
    func setDirectory(folderDestinationURL: NSURL) {
        NSUserDefaults.standardUserDefaults().setURL(folderDestinationURL, forKey: "screenCaptureDirectory")
        self.url = folderDestinationURL
        setScreenCaptureDefaultFolder(folderDestinationURL)
    }
    
    
    func setScreenCaptureDefaultFolder(directoryURL: NSURL) {
        let task = NSTask()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c",
            "defaults write com.apple.screencapture location \(directoryURL.path!); killall SystemUIServer"]
        task.launch()
    }
}
