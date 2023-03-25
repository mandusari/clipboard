//
//  ClipboardPolling.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/08.
//

import Foundation
import SwiftUI
import CoreData

class ClipboardPolling {
    private var pasteboard = NSPasteboard.general
    private var timer: Timer?
    private let dataController = PersistenceController.shared
    private var previousChangeCount = UserDefaults.standard.integer(forKey: "ClipboardChangeCount")

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self, self.pasteboard.changeCount != self.previousChangeCount else { return }
            self.previousChangeCount = self.pasteboard.changeCount
            UserDefaults.standard.set(self.previousChangeCount, forKey: "ClipboardChangeCount")

            /// 우선 Text만 체크
            if let string = self.pasteboard.string(forType: .string) {
                self.dataController.addItem(string)
            }
        }
    }
    
    public func stopPolling() {
        guard timer?.isValid == true else  { return }
        timer?.invalidate()
        timer = nil
    }
}
