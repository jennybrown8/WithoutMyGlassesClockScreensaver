//
//  ContentView.swift
//  ScreensaverPreviewApp
//
//  Created by Jenny Brown on 9/25/26.
//  Copyright © 2026 Jenny Brown. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ClockPreviewView()
            .ignoresSafeArea()
    }
}

struct ClockPreviewView: NSViewRepresentable {
    func makeNSView(context: Context) -> WithoutMyGlassesClockView {
        let view = WithoutMyGlassesClockView(frame: .zero, isPreview: false)!
        view.startAnimation()
        return view
    }
    
    func updateNSView(_ nsView: WithoutMyGlassesClockView, context: Context) {
    }
    
    static func dismantleNSView(_ nsView: WithoutMyGlassesClockView, coordinator: ()) {
        nsView.stopAnimation()
    }
}

#Preview {
    ContentView()
}
