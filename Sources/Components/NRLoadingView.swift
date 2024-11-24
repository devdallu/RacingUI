//
//  SwiftUIView.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NRLoadingView: View {
    private let text: String
    
    public init(text: String = "Loading...") {
        self.text = text
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
#Preview {
    NRLoadingView()
}
