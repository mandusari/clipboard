//
//  ContentView.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI
import CoreData
import Combine

struct StatusBarList: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.savedDate, ascending: false)],
        animation: .default)
    var items: FetchedResults<Item>
    private var pasteboard = NSPasteboard.general

    var body: some View {
        ForEach(items) { item in
            Button {
                // 선택한 텍스트를 보드에 다시 집어넣음.
                pasteboard.clearContents()
                pasteboard.setString(item.stringData ?? "", forType: .string)
                
                // command+v 단축키로 텍스트를 현재 화면에 붙여넣음.
                let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x09), keyDown: true)
                event?.flags = CGEventFlags.maskCommand
                event?.post(tap: .cghidEventTap)
            } label: {
                Text(item.stringData ?? "")
            }
        }
    }
}
