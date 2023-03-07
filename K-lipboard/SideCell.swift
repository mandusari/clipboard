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
    
struct PinIcon: View {
    var isActivate: Bool = false
    
    var body: some View {
        if isActivate {
            Image("status_bar_icon")
                .resizable()
                .frame(width: 25, height: 25)
        }
        else {
            Image("status_bar_icon")
                .resizable()
                .frame(width: 25, height: 25)
                .grayscale(0.9995)
        }
    }
}

/// 사이드메뉴 셀 모양 생성.
struct SideCell: View {
    var item: Item?
    
    var body: some View {
        HStack {
            PinIcon(isActivate: item?.isPin ?? false)
            VStack {
                CellText(size: 30, content: "\(item?.stringData ?? "")")
                CellText(size: 15, content: dateFormatter(item?.savedDate))
            }
        }
    }
    
    private func dateFormatter(_ date: Date?) -> String {
        guard let date = date else { return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}
