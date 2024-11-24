//
//  SwiftUIView.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NRButton: View {
    private let title: String
    private let icon: String?
    private let style: ButtonStyle
    private let action: () -> Void
    
    public init(
        title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: style.spacing) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.system(.body, design: .rounded).weight(.semibold))
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .frame(maxWidth: style == .block ? .infinity : nil)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(style.cornerRadius)
        }
    }
    
    public enum ButtonStyle {
        case primary
        case secondary
        case pill
        case block
        
        var backgroundColor: Color {
            switch self {
            case .primary, .block: return .orange
            case .secondary: return .orange.opacity(0.15)
            case .pill: return Color(.systemGray6)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .block: return .white
            case .secondary: return .orange
            case .pill: return .primary
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .pill: return 24
            default: return 12
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .pill: return 20
            default: return 16
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .pill: return 14
            default: return 12
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .pill: return 10
            default: return 8
            }
        }
    }
}

#Preview {
    NRButton(title: "No Races Found", action: {
        print("Button Tapped")
    })
}
