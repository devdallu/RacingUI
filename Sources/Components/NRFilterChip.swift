//
//  SwiftUIView.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NRFilterChip: View {
    private let title: String
    private let icon: String?
    private let isSelected: Bool
    private let action: () -> Void
    
    public init(
        title: String,
        icon: String? = nil,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .dynamicTypeSize(.large)
            }
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.orange : Color(.systemGray6))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

#Preview {
    NRFilterChip(title: "Horse", isSelected: true, action: {
        print("button Taped")
    })
}
