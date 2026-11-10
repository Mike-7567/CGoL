//
//  MTLViewRepresentable.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import MetalKit
import SwiftUI

struct SimulationView: NSViewRepresentable {
    @State var renderer = Renderer()
        
    @Binding var settings: SettingsStruct
    
    func makeNSView(context: Context) -> some NSView {
        let view = MTKView()
        
        view.device = DEVICE
        view.delegate = renderer
        view.preferredFramesPerSecond = 60
        view.colorPixelFormat = MAIN_COLOR_FORMAT
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        renderer.settings = settings
    }
}
