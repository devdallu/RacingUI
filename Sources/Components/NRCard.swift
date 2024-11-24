//
//  SwiftUIView.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NRCard<Content: View>: View {
    private let content: Content
    private let padding: EdgeInsets
    private let cornerRadius: CGFloat
    
    public init(
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        cornerRadius: CGFloat = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background(Color(.systemBackground))
            .cornerRadius(cornerRadius)
            .shadow(color: Color.fromBundle(named: "card", bundle: .module), radius: 8, x: 0, y: 2)
    }
}
#Preview {
    NRCard {
        Text("Racing Card Content")
            .font(.headline)
            .foregroundColor(.primary)
    }
    
}
