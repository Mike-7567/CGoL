//
//  ContentView.swift
//  CGoL
//
//  Created by Gabriel Thomson on 11/7/26.
//

import SwiftUI

struct ContentView: View {
    @Binding var settings: SettingsStruct
    
    var body: some View {
        SimulationView(settings: $settings)
    }
}
