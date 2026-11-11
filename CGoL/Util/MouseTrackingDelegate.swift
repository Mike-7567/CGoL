//
//  MouseTrackingDelagate.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/9/26.
//

import Foundation
import AppKit

protocol MouseTrackingDelegate {
    func mouseDown(with event: NSEvent)
    
    func mouseDragged(with event: NSEvent)
    
    func mouseUp(with event: NSEvent)
    
    func mouseExited(with event: NSEvent)
    
    func mouseEntered(with event: NSEvent)
}
