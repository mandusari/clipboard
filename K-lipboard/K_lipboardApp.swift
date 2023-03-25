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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        
        
        MenuBarExtra("", systemImage: "chevron.backward.to.line") {
            StatusBarList()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            
            Divider()
            Button("열기") { debugPrint("어떻게 열지...??") }
            Button("종료") { NSApplication.shared.terminate(nil) }
        }
    }
}
