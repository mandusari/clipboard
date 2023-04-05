//
//  ContentView.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI
import CoreData
import Combine
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let one = Self("one", default: .init(.one, modifiers: [.command, .option]))
    static let two = Self("two", default: .init(.two, modifiers: [.command, .option]))
    static let three = Self("three", default: .init(.three, modifiers: [.command, .option]))
    static let four = Self("four", default: .init(.four, modifiers: [.command, .option]))
    static let five = Self("five", default: .init(.five, modifiers: [.command, .option]))
    static let six = Self("six", default: .init(.six, modifiers: [.command, .option]))
    static let seven = Self("seven", default: .init(.seven, modifiers: [.command, .option]))
    static let eight = Self("eight", default: .init(.eight, modifiers: [.command, .option]))
    static let nine = Self("nine", default: .init(.nine, modifiers: [.command, .option]))
    static let zero = Self("zero", default: .init(.zero, modifiers: [.command, .option]))
}

struct StatusBarList: View {
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.isPin, ascending: false),
            NSSortDescriptor(keyPath: \Item.priorityPin, ascending: true),
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
                debugPrint("KEYVALUE = \(key)")
                let name = convertTo(key: key)
                KeyboardShortcuts.onKeyDown(for: name) {
                    pasteboard.clearContents()
                    debugPrint(item.stringData ?? "")
                    pasteboard.setString(item.stringData ?? "", forType: .string)
                    let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x09), keyDown: true)
                    event?.flags = CGEventFlags.maskCommand
                    event?.post(tap: .cghidEventTap)
                }
            }
        }
    }
    
    private func convertTo(key: Int) -> KeyboardShortcuts.Name {
        switch key {
        case 0: return .zero
        case 1: return .one
        case 2: return .two
        case 3: return .three
        case 4: return .four
        case 5: return .five
        case 6: return .six
        case 7: return .seven
        case 8: return .eight
        case 9: return .nine
        default:
            return .one
        }
    }
}

extension View {
    
    func customShortcut(_ index: Int, isPin: Bool, keyRegisterHandler: (Int) -> Void) -> some View {
        if index < 10 && isPin == true {
            let keyValue = (index+1) % 10
            keyRegisterHandler(keyValue)
            return AnyView(self.keyboardShortcut(KeyEquivalent(Character("\(keyValue)")), modifiers: [.option, .command]))
        }
        
        return AnyView(self)
    }
}
