//
//  MouseTrackingDelagate.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/9/26.
//

import Foundation

#if os(macOS)

import AppKit

protocol InputDelegate {
    func mouseDown(with event: NSEvent)
    
    func mouseDragged(with event: NSEvent)
    
    func mouseUp(with event: NSEvent)
    
    func mouseExited(with event: NSEvent)
    
    func mouseEntered(with event: NSEvent)
    
    func keyUp(with event: NSEvent)
    
    func keyDown(with event: NSEvent)
}

#elseif os(iOS)

import UIKit

protocol InputDelegate {
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
}

#endif


