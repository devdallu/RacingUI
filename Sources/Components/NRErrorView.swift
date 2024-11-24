//
//  SwiftUIView 2.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NRErrorView: View {
    private let error: String
    private let retryAction: () -> Void
    
    public init(error: String, retryAction: @escaping () -> Void) {
        self.error = error
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(alignment:.center) {
            NREmptyStateView(
                title: "Oops!",
                message: error,
                icon: "exclamationmark.triangle",
                actionTitle: "Try Again",
                action: retryAction
            )
        }
    }
}

#Preview {
    NRErrorView(error: "previewError", retryAction: {
        print("button Tapped")
    })
}
