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
    }
    
    override func loadView() {
        view = TestView(forAutoLayout: ())
        
        let layer = CALayer()
        layer.backgroundColor = CGColorCreateGenericRGB(0, 1, 0, 1)
        view.wantsLayer = true
        
        view.layer = layer
    }
}

class TestView: NSView {
    override func updateConstraints() {
        autoPinEdgesToSuperviewEdgesWithInsets(NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        super.updateConstraints()
    }
}