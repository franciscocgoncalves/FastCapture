//
//  AlbumListViewController.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 01/06/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class AlbumListViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("teste C")
    }
    
    override func loadView() {
        view = NSView(forAutoLayout: ())
        view.autoSetDimensionsToSize(CGSize(width: 300, height: 350))
    }
}
