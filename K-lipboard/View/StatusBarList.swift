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
        ForEach(items.indices, id: \.self) { index in
            Button {
                // 선택한 텍스트를 보드에 다시 집어넣음.
                pasteboard.clearContents()
                pasteboard.setString(items[index].stringData ?? "", forType: .string)
                
                // command+v 단축키로 텍스트를 현재 화면에 붙여넣음.
                let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x09), keyDown: true)
                event?.flags = CGEventFlags.maskCommand
                event?.post(tap: .cghidEventTap)
            } label: {
                let stringData = (items[index].stringData ?? "")
                Text(stringData.trimmingCharacters(in: .whitespaces).prefix(15))
            }
            .customShortcut(index)
//            .keyboardShortcut(KeyEquivalent(Character("\(index)")), modifiers: [.command, .shift])
        }
    }
    
}

extension View {
    
    public func customShortcut(_ index: Int) -> some View {
        if index < 10 {
            return self.keyboardShortcut(KeyEquivalent(Character("\(index)")), modifiers: [.command, .shift])
        }
        
        return AnyView(self)
    }
}
