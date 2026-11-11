//
//  SettingsView.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var addCells = true
    @Binding var settings: SettingsStruct
    
    var body: some View {
        VStack {
            Toggle("Add cells", isOn: $addCells).onChange(of: addCells) {
                settings.addCells = addCells ? 1 : 0
            }
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
        }.padding().frame(minWidth: 400, minHeight: 300)
    }
}
