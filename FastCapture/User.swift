//
//  User.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 05/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

private let _User = User()

class User: NSObject {
    class var sharedInstance: User {
        return _User
    }
    
    var isLoggedIn: Bool = false
    var username: String?
    var accountID: Int?
    
    func login() {
        if(IMGSession.sharedInstance().isAnonymous) {
            let delegate = NSApplication.sharedApplication().delegate as! IMGSessionDelegate
            
            let imgSession = IMGSession.authenticatedSessionWithClientID("faf27519a494215", secret: "6ba2fe23e54af0c3aed0ce862993837644f0d271", authType: IMGAuthType.CodeAuth, withDelegate: delegate)
                        
            //this request is to force auth accordingly to the library documentation
            IMGGalleryRequest.hotGalleryPage(0, withViralSort: true, success: { (array: [AnyObject]!) -> Void in
                }, failure: { (error: NSError!) -> Void in
                    println("error:\(error)")
                })
        }
    }
}
