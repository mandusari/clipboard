//
//  ContentView.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI
import HotKey

struct StatusBarList: View {
    @Environment(\.managedObjectContext) var dbContext
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.isPin, ascending: false),
            NSSortDescriptor(keyPath: \Item.priorityPin, ascending: true),
            NSSortDescriptor(keyPath: \Item.savedDate, ascending: false)
        ],
        animation: .default)
    var items: FetchedResults<Item>
    let hotkeys: [HotKey] = [HotKey(key: .zero, modifiers: [.control, .command]),
                            HotKey(key: .one, modifiers: [.control, .command]),
                             HotKey(key: .two, modifiers: [.control, .command]),
                             HotKey(key: .three, modifiers: [.control, .command]),
                             HotKey(key: .four, modifiers: [.control, .command]),
                             HotKey(key: .five, modifiers: [.control, .command]),
                             HotKey(key: .six, modifiers: [.control, .command]),
                             HotKey(key: .seven, modifiers: [.control, .command]),
                             HotKey(key: .eight, modifiers: [.control, .command]),
                             HotKey(key: .nine, modifiers: [.control, .command])]

    var body: some View {
        ForEach(items.indices, id: \.self) { index in
            
            let item = items[index]
            Button {
                // 선택한 텍스트를 보드에 다시 집어넣음.
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.stringData ?? "", forType: .string)
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
            .customShortcut(index, isPin: item.isPin) { key in
                debugPrint("key = \(key)")
                self.hotkeys[key].keyDownHandler = keyDownAction(clipText: item.stringData ?? "")
            }
        }
    }
    
    func keyDownAction(clipText: String) -> () -> () {
        return {
            NSPasteboard.general.clearContents()
            debugPrint(clipText)
            NSPasteboard.general.setString(clipText, forType: .string)
            let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x09), keyDown: true)
            event?.flags = CGEventFlags.maskCommand
            event?.post(tap: .cghidEventTap)
        }
    }
}

extension View {
    
    func customShortcut(_ index: Int, isPin: Bool, keyRegisterHandler: @escaping (Int) -> ()) -> some View {
        if index < 10 && isPin == true {
            let keyValue = (index) % 10
            keyRegisterHandler(keyValue)
            return AnyView(self.keyboardShortcut(KeyEquivalent(Character("\(keyValue)"))/*, modifiers: [.control, .command]*/))
        }
        
        return AnyView(self)
    }
}
