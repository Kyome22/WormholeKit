//
//  ContentView.swift
//  Example
//
//  Created by Takuto Nakamura on 2026/07/05.
//

import SwiftUI
import WormholeKit

struct ContentView: View {
    @Environment(\.sendIntoWormhole) var sendIntoWormhole

    var body: some View {
        VStack {
            Button("Open Alert") {
                sendIntoWormhole(id: "sample-alert", value: true)
            }
        }
        .frame(width: 200, height: 100)
        .padding()
    }
}
