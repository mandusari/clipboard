////
////  StatusBarController.swift
////  K-lipboard
////
////  Created by mandu on 2023/03/05.
////
//
//import Foundation
//import SwiftUI
//
//@main struct StatusBarApp: App {
//    
//    @State private var command: String = "a"
//       
//    var body: some Scene {
//
//        MenuBarExtra(command, systemImage: "\(command).circle") {
//           
//            Button("Uno") { command = "a" }
//                .keyboardShortcut("U")
//           
//            Button("Dos") { command = "b" }
//                .keyboardShortcut("D")
//           
//            Divider()
//
//            Button("Salir") { NSApplication.shared.terminate(nil) }
//                .keyboardShortcut("S")
//        }
//    }
//}
