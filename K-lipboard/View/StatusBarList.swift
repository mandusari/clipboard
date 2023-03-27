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
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.isPin, ascending: false),
            NSSortDescriptor(keyPath: \Item.savedDate, ascending: false)
        ],
        animation: .default)
    var items: FetchedResults<Item>
    private var pasteboard = NSPasteboard.general

    var body: some View {
        ForEach(items.indices, id: \.self) { index in
            
            let item = items[index]
            Button {
                // 선택한 텍스트를 보드에 다시 집어넣음.
                pasteboard.clearContents()
                pasteboard.setString(item.stringData ?? "", forType: .string)
                
                // command+v 단축키로 텍스트를 현재 화면에 붙여넣음.
//                let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x09), keyDown: true)
//                event?.flags = CGEventFlags.maskCommand
//                event?.post(tap: .cghidEventTap)
            } label: {
                let stringData = (item.stringData ?? "")
                HStack {
                    if item.isPin == true {
                        Image(systemName: "pin.circle")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .foregroundColor(.yellow)
                    }

                    Text(stringData.trimmingCharacters(in: .whitespaces).prefix(15))
                }
            }
            .customShortcut(index, isPin: item.isPin)
        }
    }
    
}

extension View {
    
    public func customShortcut(_ index: Int, isPin: Bool) -> some View {
        if index < 10 && isPin == true {
            return AnyView(self.keyboardShortcut(KeyEquivalent(Character("\(index)")), modifiers: [.command, .shift]))
        }
        
        return AnyView(self)
    }
}
