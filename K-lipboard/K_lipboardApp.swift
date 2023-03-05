//
//  K_lipboardApp.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI

@main
struct K_lipboardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
