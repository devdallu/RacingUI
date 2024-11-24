//
//  SwiftUIView.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NRCountdownBadge: View {
    private let time: String
    private let style: BadgeStyle
    
    public init(time: String, style: BadgeStyle = .normal) {
        self.time = time
        self.style = style
    }
    
    public var body: some View {
        Text(time)
            .font(.system(.subheadline, design: .rounded).weight(.bold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(style.backgroundColor)
            .foregroundColor(style.textColor)
            .cornerRadius(12)
    }
    
    public enum BadgeStyle {
        case normal
        case warning
        case urgent
        
        var backgroundColor: Color {
            switch self {
            case .normal: return .orange.opacity(0.15)
            case .warning: return .yellow.opacity(0.15)
            case .urgent: return .red.opacity(0.15)
            }
        }
        
        var textColor: Color {
            switch self {
            case .normal: return .orange
            case .warning: return .yellow
            case .urgent: return .red
            }
        }
    }
}

#Preview {
    NRCountdownBadge(time: "00:00:00")
}
