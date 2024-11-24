//
//  SwiftUIView.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NREmptyStateView: View {
    private let title: String
    private let message: String?
    private let icon: String
    private let action: (() -> Void)?
    private let actionTitle: String?
    
    public init(
        title: String,
        message: String? = nil,
        icon: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(title)
                .font(.headline)
            
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let action = action, let actionTitle = actionTitle {
                NRButton(
                    title: actionTitle,
                    style: .secondary,
                    action: action
                )
            }
        }
        .padding()
    }
}

#Preview {
    NREmptyStateView(title: "No data found", message: "No data available for this time range", icon: "exclamationmark.triangle.fill")
}
