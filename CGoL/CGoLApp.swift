//
//  CGoLApp.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import SwiftUI
import simd

let DEFAULT_SETTINGS = SettingsStruct(DataTextureSize: simd_int2(500, 500), addCells: 1, updateRate: 1)

@main
struct CGoLApp: App {
    @State private var settings: SettingsStruct = DEFAULT_SETTINGS
    
    init() {
        ComputePiplines.initialize()
        RenderPipelines.initialize()
        Textures.initialize(size: settings.DataTextureSize)
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
