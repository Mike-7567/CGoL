//
//  MTKMouseTrackingView.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/9/26.
//

import MetalKit

class MTKInputView: MTKView {
    var inputDelegate: InputDelegate?
    
    #if os(macOS)
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        guard let delegate = inputDelegate else {
            return
        }
        delegate.mouseDown(with: event)
    }

    override func mouseDragged(with event: NSEvent) {
        guard let delegate = inputDelegate else {
            return
        }
        delegate.mouseDragged(with: event)
    }

    override func mouseUp(with event: NSEvent) {
        guard let delegate = inputDelegate else {
            return
        }
        delegate.mouseUp(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        guard let delegate = inputDelegate else {
            return
        }
        delegate.mouseExited(with: event)
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let delegate = inputDelegate else {
            return
        }
        delegate.mouseEntered(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        if (inputDelegate != nil) {
            inputDelegate?.keyUp(with: event)
        }
        super.keyUp(with: event)
    }
    
    override func keyDown(with event: NSEvent) {
        if (inputDelegate != nil) {
            inputDelegate?.keyDown(with: event)
        }
        super.keyDown(with: event)
    }
    
    func becameKeyView() {
        window?.makeFirstResponder(self)
    }
    
    override func viewDidMoveToWindow() {
        becameKeyView()
    }
    #elseif os(iOS)
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (inputDelegate != nil) {
            inputDelegate?.touchesMoved(touches, with: event)
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (inputDelegate != nil) {
            inputDelegate?.touchesBegan(touches, with: event)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (inputDelegate != nil) {
            inputDelegate?.touchesEnded(touches, with: event)
        }
        super.touchesEnded(touches, with: event)
    }
    
    #endif
}
