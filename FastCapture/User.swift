//
//  User.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 05/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class User: NSObject {
    //TODO: - Make this a singleton, add user properties
    
    func login() {
        if(IMGSession.sharedInstance().isAnonymous) {
            println("Loggin in")
            
            let delegate = NSApplication.sharedApplication().delegate as! IMGSessionDelegate
            
            let imgSession = IMGSession.authenticatedSessionWithClientID("3ad48f8fb1be413", secret: "0e2b2f6e637cdfa9aa17b5984772a6353718fac5", authType: IMGAuthType.CodeAuth, withDelegate: delegate)
            
            //this request is to force auth accordingly to the library documentation
            IMGGalleryRequest.hotGalleryPage(0, withViralSort: true, success: { (array: [AnyObject]!) -> Void in
                println("request bem sucedido")
                }, failure: { (error: NSError!) -> Void in
                    println("error:\(error)")
                })
        }
    }
}
