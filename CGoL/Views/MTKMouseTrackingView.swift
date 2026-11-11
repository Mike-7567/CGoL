//
//  MTKMouseTrackingView.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/9/26.
//

import MetalKit

class MTKMouseTrackingView: MTKView {
    var mouseDelegate: MouseTrackingDelegate?
    
    override func mouseDown(with event: NSEvent) {
        guard let delegate = mouseDelegate else {
            return
        }
        delegate.mouseDown(with: event)
    }

    override func mouseDragged(with event: NSEvent) {
        guard let delegate = mouseDelegate else {
            return
        }
        delegate.mouseDragged(with: event)
    }

    override func mouseUp(with event: NSEvent) {
        guard let delegate = mouseDelegate else {
            return
        }
        delegate.mouseUp(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        guard let delegate = mouseDelegate else {
            return
        }
        delegate.mouseExited(with: event)
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let delegate = mouseDelegate else {
            return
        }
        delegate.mouseEntered(with: event)
    }
}
