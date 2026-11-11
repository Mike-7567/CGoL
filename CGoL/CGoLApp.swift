//
//  CGoLApp.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import SwiftUI
import simd

let DEFAULT_SETTINGS = SettingsStruct(dataTextureSize: simd_int2(400, 200), addCells: 0, updateRate: 2, strokeSize: 3.0)

@main
struct CGoLApp: App {
    @State private var settings: SettingsStruct = DEFAULT_SETTINGS
    
    init() {
        ComputePiplines.initialize()
        RenderPipelines.initialize()
        Textures.initialize(size: settings.dataTextureSize)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(settings: $settings)
        }
        Settings {
            SettingsView(settings: $settings)
        }
    }
}
