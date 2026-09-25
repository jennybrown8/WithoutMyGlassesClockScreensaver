//
//  ScreensaverPreviewAppApp.swift
//  ScreensaverPreviewApp
//
//  Created by Jenny Brown on 9/25/26.
//  Copyright © 2026 Jenny Brown. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct ScreensaverPreviewAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
