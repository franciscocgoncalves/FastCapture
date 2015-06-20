//
//  PanelViewController.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 01/05/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class PanelViewController: NSViewController, PanelViewDelegate, ScreenCaptureDelegate {
    var panelView: PanelView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreenCapture.sharedInstance.delegate = self
        
        panelView?.delegate = self
        addLastScreenCaptureURL(NSUserDefaults.standardUserDefaults().URLForKey("lastCapture")!)

    }
    
    override func loadView() {
        view = NSView(forAutoLayout: ())
        view.autoSetDimensionsToSize(CGSize(width: 300, height: 350))
        
        panelView = PanelView(forAutoLayout: ())
        
        view.addSubview(panelView!)
        view.updateConstraints()
    }
    
    override func viewDidLayout () {

    }
    
    //MARK: - PanelViewDelegate
    func copyLastScreenCaptureAction () {
        let fileURL = NSUserDefaults.standardUserDefaults().URLForKey("lastCapture")
        
        if let urlDescription = fileURL?.description  {
            NSPasteboard.generalPasteboard().clearContents()
            NSPasteboard.generalPasteboard().setString(urlDescription, forType: NSStringPboardType)
        }
    }
    
    func albumListAction () {
        let albumListViewController = AlbumListViewController()
        
        panelView?.removeFromSuperview()
        view.addSubview(albumListViewController.view)
    }
    
    func login() {
        User.sharedInstance.login()
    }
    
    //TODO: - make view
    func settings() {
    }
    
    //TODO: - Add paypal url
    func donate() {
        let url = NSURL(string: "someURL")
        NSWorkspace.sharedWorkspace().openURL(url!)
    }
    
    func reportABug() {
        let url = NSURL(string: "https://github.com/franciscocgoncalves/FastCapture/issues")
        NSWorkspace.sharedWorkspace().openURL(url!)
    }
    
    func quitFastCapture() {
        NSApplication.sharedApplication().terminate(nil)
    }
    
    //MARK: - ScreenCapture Delegate
    
    func addLastScreenCaptureURL(fileURL: NSURL) {
        panelView?.lastScreenCaptureURL = fileURL
        downloadLastScreencapture(fileURL)
    }
    
    func uploadingScreenCaptureProgress() {
        //TODO: - implement progress
    }
    
    func downloadLastScreencapture (fileURL: NSURL) {
        let urlRequest = NSURLRequest(URL: fileURL)
        let requestOperation = AFHTTPRequestOperation(request: urlRequest)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        
        requestOperation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            self.panelView?.lastScreenCaptureImageView.image = responseObject as? NSImage
            self.panelView?.needsUpdateConstraints = true

            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
        })
        
        requestOperation.start()
    }
}
