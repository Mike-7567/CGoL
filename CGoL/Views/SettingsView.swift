//
//  SettingsView.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @State private var addCells = true
    @Binding var settings: SettingsStruct
    
    var body: some View {
        VStack {
            Stepper("Update Rate \(settings.updateRate)") {
                settings.updateRate += 1
            } onDecrement: {
                if (settings.updateRate > 0) {
                    settings.updateRate -= 1
                }
            }
            Slider(value: $settings.strokeSize, in: 0...10) {
                Text("Stroke size: \(settings.strokeSize)")
            }
            //Button("Reset size") {
            //    guard let size = NSScreen.main?.frame else {
            //        print("Could not get main screen frame")
            //        return
            //    }
            //    Textures.resetTextures(size: simd_int2(Int32(size.width), Int32(size.height)))
            //}
        }.padding().frame(minWidth: 400, minHeight: 300)
    }
}
