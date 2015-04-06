//
//  BackgroundView.swift
//  FastCapture
//
//  Created by Francisco Gonçalves on 03/04/15.
//  Copyright (c) 2015 Francisco Gonçalves. All rights reserved.
//

import Cocoa

class BackgroundView: NSView {
    let FILL_OPACITY: CGFloat = 0.9
    let STROKE_OPACITY: CGFloat = 1.0
    
    let LINE_THICKNESS: CGFloat = 1.0
    let CORNER_RADIUS: CGFloat = 6.0
    
    let ARROW_WIDTH: CGFloat = 12
    
    private var _arrowX: Int?
    var arrowX: Int? {
        get {
            return _arrowX
        }
        set {
            _arrowX = newValue
            self.needsDisplay = true
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        let contentRect = NSInsetRect(self.bounds, LINE_THICKNESS, LINE_THICKNESS)
        let path = NSBezierPath()
        
        //Draw Arrow
        if let arrowX = self.arrowX {
            let arrowX = CGFloat(arrowX)
            let arrowHeight = CGFloat(Float(ARROW_HEIGHT))
            
            path.moveToPoint(NSMakePoint(arrowX, NSMaxY(contentRect)))
            path.lineToPoint(NSMakePoint(arrowX + ARROW_WIDTH / CGFloat(10), NSMaxY(contentRect) - arrowHeight))
            path.lineToPoint(NSMakePoint(NSMaxX(contentRect) - CORNER_RADIUS, NSMaxY(contentRect) - arrowHeight))
            
            
            //Draw Rect
            //Top Right Corner
            let topRightCorner = NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) - arrowHeight)
            path.curveToPoint(NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) -  arrowHeight - CORNER_RADIUS), controlPoint1: topRightCorner, controlPoint2: topRightCorner)
            
            path.lineToPoint(NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect) + CORNER_RADIUS))
            
            //Bottom Right Corner
            let bottomRightCorner = NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect))
            path.curveToPoint(NSMakePoint(NSMaxX(contentRect) -  CORNER_RADIUS, NSMinY(contentRect)), controlPoint1: bottomRightCorner, controlPoint2: bottomRightCorner)
            
            path.lineToPoint(NSMakePoint(NSMinX(contentRect) + CORNER_RADIUS, NSMinY(contentRect)))
            
            //Bottom Left Corner
            let bottomLeftCorner = contentRect.origin
            path.curveToPoint(NSMakePoint(NSMinX(contentRect), NSMinY(contentRect) + CORNER_RADIUS), controlPoint1: bottomLeftCorner, controlPoint2: bottomLeftCorner)
            
            path.lineToPoint(NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - arrowHeight - CORNER_RADIUS))
            
            //Top Left Corner
            let topLeftCorner = NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - arrowHeight)
            path.curveToPoint(NSMakePoint(NSMinX(contentRect) + CORNER_RADIUS, NSMaxY(contentRect) - arrowHeight), controlPoint1: topLeftCorner, controlPoint2: topLeftCorner)
            
            path.lineToPoint(NSMakePoint(arrowX - ARROW_WIDTH / 2, NSMaxY(contentRect) - arrowHeight))
            path.closePath()
            
            NSColor(deviceWhite: 1, alpha: FILL_OPACITY).setFill()
            path.fill()
            
            NSGraphicsContext.saveGraphicsState()
            let clip = NSBezierPath(rect: self.bounds)
            clip.appendBezierPath(path)
            clip.addClip()
            
            path.lineWidth = LINE_THICKNESS * 2
            NSColor.whiteColor().setStroke()
            path.stroke()
            NSGraphicsContext.restoreGraphicsState()
            super.drawRect(dirtyRect)
        }
    }
    
}
