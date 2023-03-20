//
//  K_lipboardApp.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI

@main
struct K_lipboardApp: App {
    @Environment(\.scenePhase) var scenePhase
    private let polling = ClipboardPolling()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
