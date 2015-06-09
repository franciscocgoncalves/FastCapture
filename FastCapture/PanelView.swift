//
//  PanelView.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 09/06/15.
//  Copyright © 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class PanelView: NSView {
    var _titleLabel: NSTextField?
    var titleLabel: NSTextField {
        if(_titleLabel == nil) {
            _titleLabel = NSTextField(forAutoLayout: ())
            
            _titleLabel!.stringValue = "FastCapture"
            _titleLabel!.editable = false
            _titleLabel!.bezeled = false
            _titleLabel!.drawsBackground = false
        }
        return _titleLabel!
    }
    
    var _takeFirstScreenCaptureLabel: NSTextField?
    var takeFirstScreenCaptureLabel: NSTextField {
        if (_takeFirstScreenCaptureLabel == nil) {
            _takeFirstScreenCaptureLabel = NSTextField(forAutoLayout: ())
            
            _takeFirstScreenCaptureLabel!.stringValue = "Take your first ScreenCapture"
            _takeFirstScreenCaptureLabel!.editable = false
            _takeFirstScreenCaptureLabel!.bezeled = false
            _takeFirstScreenCaptureLabel!.drawsBackground = false
        }
        return _takeFirstScreenCaptureLabel!
    }
    
    var _placeholderView: NSView?
    var placeholderView: NSView {
        if (_placeholderView == nil) {
            _placeholderView = NSView(forAutoLayout: ())
        }
        return _placeholderView!
    }
    
    var _bottomPlaceholderView: NSView?
    var bottomPlaceholderView: NSView {
        if (_bottomPlaceholderView == nil) {
            _bottomPlaceholderView = NSView(forAutoLayout: ())
        }
        return _bottomPlaceholderView!
    }
    
    var _lastScreenCaptureImagePlaceholderView: NSView?
    var lastScreenCaptureImagePlaceholderView: NSView {
        if (_lastScreenCaptureImagePlaceholderView == nil) {
            _lastScreenCaptureImagePlaceholderView = NSView(forAutoLayout: ())
        }
        return _lastScreenCaptureImagePlaceholderView!
    }
    
    var _topLineView: NSBox?
    var topLineView: NSBox {
        if (_topLineView == nil) {
            _topLineView = NSBox(forAutoLayout: ())
            _topLineView!.boxType = NSBoxType.Separator
        }
        return _topLineView!
    }
    
    var _bottomLineView: NSBox?
    var bottomLineView: NSBox {
        if (_bottomLineView == nil) {
            _bottomLineView = NSBox(forAutoLayout: ())
            _bottomLineView!.boxType = NSBoxType.Separator
        }
        return _bottomLineView!
    }
    
    
    var _lastScreenCaptureView: NSImageView?
    var lastScreenCaptureView: NSImageView {
        if(_lastScreenCaptureView == nil) {
            _lastScreenCaptureView = NSImageView(forAutoLayout: ())
        }
        
        return _lastScreenCaptureView!
    }
    
    var lastScreenCaptureImage: NSImage?
    
    var _lastScreenCaptureLabel: NSTextField?
    var lastScreenCaptureLabel: NSTextField {
        if (_lastScreenCaptureLabel == nil) {
            _lastScreenCaptureLabel = NSTextField(forAutoLayout: ())
            
            //TODO: - remove next line
            _lastScreenCaptureLabel!.stringValue = "Last uploaded: http://www.google.com"
            _lastScreenCaptureLabel!.editable = false
            _lastScreenCaptureLabel!.bezeled = false
            _lastScreenCaptureLabel!.drawsBackground = false
        }
        return _lastScreenCaptureLabel!
    }
    
    var _copyLastScreenCaptureButton: NSButton?
    var copyLastScreenCaptureButton: NSButton {
        if (_copyLastScreenCaptureButton == nil) {
            _copyLastScreenCaptureButton = NSButton(forAutoLayout: ())
            
            _copyLastScreenCaptureButton!.image = NSImage(named: "save")
            _copyLastScreenCaptureButton!.alternateImage = NSImage(named: "saveHighlighted")
            
            _copyLastScreenCaptureButton!.action = Selector("copyLastScreenCaptureAction")
            _copyLastScreenCaptureButton!.target = self
            
            (_copyLastScreenCaptureButton!.cell as? NSButtonCell)?.imageScaling = .ScaleProportionallyUpOrDown
            
            _copyLastScreenCaptureButton?.bordered = false
            _copyLastScreenCaptureButton?.setButtonType(NSButtonType.MomentaryChangeButton)
            _copyLastScreenCaptureButton?.imagePosition = .ImageOnly
        }
        return _copyLastScreenCaptureButton!
    }
    
    var _albumsListButton: NSButton?
    var albumsListButton: NSButton {
        if (_albumsListButton == nil) {
            _albumsListButton = NSButton(forAutoLayout: ())
            
            _albumsListButton!.image = NSImage(named: "save")
            _albumsListButton!.alternateImage = NSImage(named: "saveHighlighted")
            
            _albumsListButton!.action = Selector("copyLastScreenCaptureAction")
            _albumsListButton!.target = self
            
            (_albumsListButton!.cell as? NSButtonCell)?.imageScaling = .ScaleProportionallyUpOrDown
            
            _albumsListButton?.bordered = false
            _albumsListButton?.setButtonType(NSButtonType.MomentaryChangeButton)
            _albumsListButton?.imagePosition = .ImageOnly
        }
        return _albumsListButton!
    }
    
    var _settingsButton: NSButton?
    var settingsButton: NSButton {
        if (_settingsButton == nil) {
            _settingsButton = NSButton(forAutoLayout: ())
            
            _settingsButton!.image = NSImage(named: "testSettings")
            _settingsButton!.alternateImage = NSImage(named: "saveHighlighted")
            
            _settingsButton!.action = Selector("copyLastScreenCaptureAction")
            _settingsButton!.target = self
            
            (_settingsButton!.cell as? NSButtonCell)?.imageScaling = .ScaleProportionallyUpOrDown
            
            _settingsButton?.bordered = false
            _settingsButton?.setButtonType(NSButtonType.MomentaryChangeButton)
            _settingsButton?.imagePosition = .ImageOnly
        }
        return _settingsButton!
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    //MARK: - Draw Views
    func drawTitleView () {
        drawTitleLabel()
        drawLineTop()
    }
    
    func drawBottomView () {
        self.addSubview(bottomPlaceholderView)
        
        bottomPlaceholderView.autoSetDimension(.Height, toSize: 50)
        bottomPlaceholderView.autoPinEdgeToSuperviewEdge(.Bottom)
        bottomPlaceholderView.autoPinEdgeToSuperviewEdge(.Left)
        bottomPlaceholderView.autoPinEdgeToSuperviewEdge(.Right)
        
        drawLineBottom()
        drawAlbumsListButton()
        drawSettingsButton()
    }
    
    func drawAlbumsListButton () {
        bottomPlaceholderView.addSubview(albumsListButton)
        
        albumsListButton.autoSetDimensionsToSize(CGSize(width: 25, height: 20))
        albumsListButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 15)
        albumsListButton.autoAlignAxis(.Horizontal, toSameAxisOfView: bottomPlaceholderView)
    }
    
    func drawSettingsButton () {
        bottomPlaceholderView.addSubview(settingsButton)
        
        settingsButton.autoSetDimensionsToSize(CGSize(width: 25, height: 20))
        settingsButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15)
        settingsButton.autoAlignAxis(.Horizontal, toSameAxisOfView: bottomPlaceholderView)
    }
    
    func drawLastCapturedView () {
        self.addSubview(placeholderView)
        
        placeholderView.autoPinEdge(.Top, toEdge: .Bottom, ofView: topLineView)
        placeholderView.autoPinEdge(.Bottom, toEdge: .Top, ofView: bottomLineView)
        placeholderView.autoPinEdgeToSuperviewEdge(.Left)
        placeholderView.autoPinEdgeToSuperviewEdge(.Right)
        
        lastScreenCaptureImage = NSImage(named: "AppIcon")
        lastScreenCaptureView.image = lastScreenCaptureImage
        
        
        guard lastScreenCaptureImage != nil else {
            drawTakeFirstScreenCaptureLabel()
            return
        }
        
        drawLastScreenCaptureLabel()
        drawLastScreenCaptureButton()
        drawLastScreenCaptureImagePlaceholder()
    }
    
    //MARK: - Draw Elements Of Views
    func drawTitleLabel () {
        self.addSubview(titleLabel)
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        titleLabel.autoAlignAxis(.Vertical, toSameAxisOfView: view)
    }
    
    func drawLineTop () {
        self.addSubview(topLineView)
        
        topLineView.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 20)
        topLineView.autoPinEdgeToSuperviewEdge(.Left)
        topLineView.autoPinEdgeToSuperviewEdge(.Right)
    }
    
    func drawLineBottom () {
        bottomPlaceholderView.addSubview(bottomLineView)
        
        bottomLineView.autoPinEdgeToSuperviewEdge(.Top)
        bottomLineView.autoPinEdgeToSuperviewEdge(.Left)
        bottomLineView.autoPinEdgeToSuperviewEdge(.Right)
    }
    
    func drawTakeFirstScreenCaptureLabel () {
        placeholderView.addSubview(takeFirstScreenCaptureLabel)
        
        takeFirstScreenCaptureLabel.autoCenterInSuperview()
    }
    
    func drawLastScreenCaptureImagePlaceholder () {
        placeholderView.addSubview(lastScreenCaptureImagePlaceholderView)
        
        lastScreenCaptureImagePlaceholderView.autoPinEdgeToSuperviewEdge(.Top)
        lastScreenCaptureImagePlaceholderView.autoPinEdge(.Bottom, toEdge: .Top, ofView: lastScreenCaptureLabel)
        lastScreenCaptureImagePlaceholderView.autoPinEdgeToSuperviewEdge(.Left)
        lastScreenCaptureImagePlaceholderView.autoPinEdgeToSuperviewEdge(.Right)
        
        drawLastScreenCaptureImage()
    }
    
    func drawLastScreenCaptureImage () {
        lastScreenCaptureImagePlaceholderView.addSubview(lastScreenCaptureView)
        
        lastScreenCaptureView.autoCenterInSuperview()
    }
    
    func drawLastScreenCaptureLabel () {
        placeholderView.addSubview(lastScreenCaptureLabel)
        
        lastScreenCaptureLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15)
        lastScreenCaptureLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
    }
    
    func drawLastScreenCaptureButton () {
        placeholderView.addSubview(copyLastScreenCaptureButton)
        
        copyLastScreenCaptureButton.autoSetDimensionsToSize(CGSize(width: 25, height: 20))
        copyLastScreenCaptureButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 15)
        copyLastScreenCaptureButton.autoAlignAxis(.Horizontal, toSameAxisOfView: lastScreenCaptureLabel)
    }

    
}
