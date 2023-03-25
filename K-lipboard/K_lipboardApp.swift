//
//  K_lipboardApp.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI

@main
struct K_lipboardApp: App {
    private let polling = ClipboardPolling()
    @Environment(\.openWindow) var openWindow

    var body: some Scene {
        WindowGroup("K-lipboard", id: "Main-Window") {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        
        
        MenuBarExtra("K-lipboard", systemImage: "chevron.backward.to.line") {
            StatusBarList()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            Divider()
            Button("열기") { openWindow(id:"Main-Window") }
            Button("종료") { NSApplication.shared.terminate(nil) }
        }
        .menuBarExtraStyle(.menu)
    }
}
