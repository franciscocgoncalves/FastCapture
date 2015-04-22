//
//  Keys.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 22/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class Keys: NSObject {
    let keysValuesDict: NSDictionary
    
    var _anonymousClientId: String?
    var anonymousClientId: String {
        get {
            if _anonymousClientId == nil {
                _anonymousClientId = keysValuesDict.objectForKey("anonymousClientId") as? String
            }
            
            return _anonymousClientId!
        }
    }
    
    var _authenticatedClientId: String?
    var authenticatedClientId: String {
        get {
            if _authenticatedClientId == nil {
                _authenticatedClientId = keysValuesDict.objectForKey("authenticatedClientId") as? String
            }
            
            return _authenticatedClientId!
        }
    }
    
    var _authenticatedSecret: String?
    var authenticatedSecret: String {
        get {
            if _authenticatedSecret == nil {
                _authenticatedSecret = keysValuesDict.objectForKey("authenticatedSecret") as? String
            }
            
            return _authenticatedSecret!
        }
    }
    
    override init() {
        let keyValuesPath = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")!
        keysValuesDict = NSDictionary(contentsOfFile: keyValuesPath as String)!
    }
}
