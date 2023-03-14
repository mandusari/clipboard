//
//  ClipboardPolling.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/08.
//

import Foundation
import SwiftUI
import CoreData

class ClipboardPolling: ObservableObject {
    private var previousChangeCount = 0
    private var pasteboard = UIPasteboard.general
    private var timer: Timer?
        
    @Published var string: String?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self, self.pasteboard.changeCount != self.previousChangeCount else { return }
            self.previousChangeCount = self.pasteboard.changeCount
            
            /// 우선 Text만 체크
            if self.pasteboard.hasStrings, let string = self.pasteboard.string {
                self.string = string
            }
        }
    }
    
    public func stopPolling() {
        guard timer?.isValid == true else  { return }
        timer?.invalidate()
        timer = nil
    }
}
