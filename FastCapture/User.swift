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
        let delegate = NSApplication.sharedApplication().delegate as! IMGSessionDelegate
        
        IMGSession.authenticatedSessionWithClientID(Keys().authenticatedClientId, secret: Keys().authenticatedSecret, authType: IMGAuthType.CodeAuth, withDelegate: delegate)
        
        IMGSession.sharedInstance().authenticate()
    }
}
