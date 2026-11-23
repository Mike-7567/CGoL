//
//  MTLViewRepresentable.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import MetalKit
import SwiftUI

import SwiftUI

#if os(iOS)
import UIKit
public typealias PlatformView = UIView
public typealias PlatformViewRepresentable = UIViewRepresentable
#elseif os(macOS)
import AppKit
public typealias PlatformView = NSView
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif

struct SimulationView: PlatformViewRepresentable {
    @State var renderer = Renderer()
        
    @Binding var settings: SettingsStruct
    
    #if os(iOS) || os(tvOS) || os(visionOS) || targetEnvironment(macCatalyst)
    func makeUIView(context: Context) -> UIView {
        makeView(context: context)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        updateView(uiView, context: context)
    }
    #elseif os(macOS)
    func makeNSView(context: Context) -> NSView {
        makeView(context: context)
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        updateView(nsView, context: context)
    }
    #endif

    private func makeView(context: Context) -> PlatformView {
        let view = MTKInputView()
        
        view.device = DEVICE
        view.inputDelegate = renderer
        view.delegate = renderer
        view.preferredFramesPerSecond = 60
        view.colorPixelFormat = MAIN_COLOR_FORMAT
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        return view
    }

    private func updateView(_ view: PlatformView, context: Context) {
        renderer.settings = settings
    }
}
