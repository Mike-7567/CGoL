//
//  CGoLApp.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import SwiftUI
import simd

#if os(macOS)
let DEFAULT_SETTINGS = SettingsStruct(dataTextureSize: simd_int2(1920, 1080), state: Running, updateRate: 2, strokeSize: 3.0)
#elseif os(iOS)
let DEFAULT_SETTINGS = SettingsStruct(dataTextureSize: simd_int2(200, 500), state: Running, updateRate: 2, strokeSize: 3.0)
#endif

@main
struct CGoLApp: App {
    @State private var settings: SettingsStruct = DEFAULT_SETTINGS
    
    init() {
        ComputePiplines.initialize()
        RenderPipelines.initialize()
        Textures.initialize(size: settings.dataTextureSize)
    }
    
    #if os(macOS)
    var body: some Scene {
        WindowGroup {
            ContentView(settings: $settings)
        }
        Settings {
            SettingsView(settings: $settings)
        }
    }
    #elseif os(iOS)
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Game", systemImage: "gamecontroller") {
                    ContentView(settings: $settings)
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView(settings: $settings)
                }
            }
        }
    }
    #endif
}
