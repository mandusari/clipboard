//
//  SideCell.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/07.
//

import Foundation
import SwiftUI

/// 텍스트 셋팅 통일 하기 위해 따로 생성.
struct CellText: View {
    var size: CGFloat = 0
    var content: String = ""
    
    var body: some View {
        Text(content)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.system(size: size))
            .lineLimit(1)
    }
}
    
/// 사이드메뉴 셀 모양 생성.
struct SideCell: View {
    var pinAction: () -> Void // Coredata에 직접 쓰기!
    @State var item: Item?

    var body: some View {
        HStack {
            Button {
                setPin()
            } label: {
                if item?.isPin ?? false {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                }
                else {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .grayscale(0.9995)
                }
            }
            VStack {
                CellText(size: 30, content: "\(item?.stringData ?? "")")
                CellText(size: 15, content: dateFormatter(item?.savedDate))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func setPin() {
        guard let item = item else { return }
        item.isPin = !item.isPin
        if item.isPin == false {
            item.priorityPin = -1
        }
        pinAction()
    }

    private func dateFormatter(_ date: Date?) -> String {
        guard let date = date else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

