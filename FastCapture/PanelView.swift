//
//  PanelView.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 09/06/15.
//  Copyright © 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class PanelView: NSView {
    var delegate: PanelViewDelegate?
    var constraintsSet = false
    
    var lastScreenCaptureURL: NSURL? {
        didSet {
            lastScreenCaptureLabel.stringValue = lastScreenCaptureURL!.description
        }
    }
    
    var _titleLabel: NSTextField?
    var titleLabel: NSTextField {
        if(_titleLabel == nil) {
            _titleLabel = NSTextField(forAutoLayout: ())
            
            _titleLabel!.stringValue = "Fast Capture"
            _titleLabel!.font = NSFont.boldSystemFontOfSize(13)
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
    
    
    var _lastScreenCaptureImageView: NSImageView?
    var lastScreenCaptureImageView: NSImageView {
        if(_lastScreenCaptureImageView == nil) {
            _lastScreenCaptureImageView = NSImageView(forAutoLayout: ())
        }
        
        return _lastScreenCaptureImageView!
    }
    
    var lastScreenCaptureImage: NSImage?
    
    var _lastScreenCaptureLabel: NSTextField?
    var lastScreenCaptureLabel: NSTextField {
        if (_lastScreenCaptureLabel == nil) {
            _lastScreenCaptureLabel = NSTextField(forAutoLayout: ())
            
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
            _copyLastScreenCaptureButton?.toolTip = "Share!"
        }
        return _copyLastScreenCaptureButton!
    }
    
    var _albumsListButton: NSButton?
    var albumsListButton: NSButton {
        if (_albumsListButton == nil) {
            _albumsListButton = NSButton(forAutoLayout: ())
            
            _albumsListButton!.image = NSImage(named: "testList")
            _albumsListButton!.alternateImage = NSImage(named: "testListHighlighted")
            
            _albumsListButton!.action = Selector("albumListAction")
            _albumsListButton!.target = self
            
            (_albumsListButton!.cell as? NSButtonCell)?.imageScaling = .ScaleProportionallyUpOrDown
            
            _albumsListButton?.bordered = false
            _albumsListButton?.setButtonType(.MomentaryChangeButton)
            _albumsListButton?.imagePosition = .ImageOnly
        }
        return _albumsListButton!
    }
    
    var _loginButton: NSButton?
    var loginButton: NSButton {
        if (_loginButton == nil) {
            _loginButton = NSButton(forAutoLayout: ())
            
            _loginButton!.action = Selector("loginAction")
            _loginButton!.target = self
            
            _loginButton!.stringValue = "Login"
            
            _loginButton?.bordered = false
            _loginButton?.setButtonType(.MomentaryChangeButton)
        }
        return _albumsListButton!
    }
    
    var _settingsButton: NSButton?
    var settingsButton: NSButton {
        if (_settingsButton == nil) {
            _settingsButton = NSButton(forAutoLayout: ())
            
            _settingsButton!.image = NSImage(named: "testSettings")
            _settingsButton!.alternateImage = NSImage(named: "testSettings")
            
            _settingsButton!.action = Selector("settingsButtonAction")
            _settingsButton!.target = self
            
            (_settingsButton!.cell as? NSButtonCell)?.imageScaling = .ScaleProportionallyUpOrDown
            
            _settingsButton?.bordered = false
            _settingsButton?.setButtonType(NSButtonType.MomentaryChangeButton)
            _settingsButton?.imagePosition = .ImageOnly
        }
        return _settingsButton!
    }
    
    var _settingsMenu: NSMenu?
    var settingsMenu: NSMenu {
        if _settingsMenu == nil {
            _settingsMenu = NSMenu()
            
            _settingsMenu?.addItemWithTitle("Settings", action: "settings", keyEquivalent: "")
            _settingsMenu?.addItemWithTitle("Report a bug", action: "reportABug", keyEquivalent: "")
            _settingsMenu?.addItemWithTitle("Donate!", action: "donate", keyEquivalent: "")
            _settingsMenu?.addItemWithTitle("Quit FastCapture", action: "quitFastCapture", keyEquivalent: "")
        }
        
        return _settingsMenu!
    }
    
    override func updateConstraints() {
        if !constraintsSet {
            autoPinEdgesToSuperviewEdgesWithInsets(NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            drawTitleView()
            drawBottomView();
            drawLastCapturedView()
            constraintsSet = true
        }
        super.updateConstraints()
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
        
        drawSettingsButton()

        guard let delegate = delegate else {
            return
        }
        
        if delegate.isLoggedIn() {
            self.drawLoginButton()
        }
        else {
            self.drawAlbumsListButton()
        }

    }
    
    func drawLoginButton () {
        
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
        
        
        guard lastScreenCaptureURL != nil else {
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
        titleLabel.autoAlignAxisToSuperviewAxis(.Vertical)
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
        
        lastScreenCaptureImagePlaceholderView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        lastScreenCaptureImagePlaceholderView.autoPinEdge(.Bottom, toEdge: .Top, ofView: lastScreenCaptureLabel, withOffset: -10)
        lastScreenCaptureImagePlaceholderView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        lastScreenCaptureImagePlaceholderView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        
        drawLastScreenCaptureImage()
    }
    
    func drawLastScreenCaptureImage () {
        lastScreenCaptureImagePlaceholderView.addSubview(lastScreenCaptureImageView)
        
        lastScreenCaptureImageView.imageScaling = NSImageScaling.ScaleProportionallyDown
        lastScreenCaptureImageView.autoPinEdgesToSuperviewEdgesWithInsets(NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
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
    
    func loginAction () {
        delegate?.login()
    }

    
    func copyLastScreenCaptureAction () {
        delegate?.copyLastScreenCaptureAction()
    }
    
    func albumListAction () {
        delegate?.albumListAction()
    }
    
    func settingsButtonAction() {
        NSMenu.popUpContextMenu(settingsMenu, withEvent: NSApp.currentEvent!, forView: self)
    }
    
    func settings() {
        delegate?.settings()
    }
    
    func donate() {
        delegate?.donate()
    }
    
    func reportABug() {
        delegate?.reportABug()
    }
    
    func quitFastCapture() {
        delegate?.quitFastCapture()
    }
    
}

protocol PanelViewDelegate {
    func copyLastScreenCaptureAction()
    func albumListAction()
    func isLoggedIn() -> Bool
    func login()
    func settings()
    func donate()
    func reportABug()
    func quitFastCapture()
}
