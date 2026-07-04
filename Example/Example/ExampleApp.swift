//
//  ExampleApp.swift
//  Example
//
//  Created by Takuto Nakamura on 2026/07/05.
//

import SwiftUI
import WormholeKit

@main
struct ExampleApp: App {
    @WormholeState(id: "sample-alert") var showingAlert = false

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)

        AlertScene(Text("Sample Alert"), isPresented: $showingAlert, actions: {})
    }
}
