//
//  File.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 22/11/24.
//

import Foundation
import SwiftUI

public struct AnimatedClearIcon: View {
    @Binding var selectedCategories: [String]
    public var clearAction: () -> Void
    
    public init(
        selectedCategories: Binding<[String]>,
        clearAction: @escaping () -> Void
    ) {
        self._selectedCategories = selectedCategories
        self.clearAction = clearAction
    }
    
    public var body: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.red)
            .scaleEffect(selectedCategories.isEmpty ? 0.8 : 1.0)
            .rotationEffect(Angle(degrees: selectedCategories.isEmpty ? 0 : 360))
            .animation(.bouncy, value: selectedCategories.isEmpty)
            .animation(.spring(), value: selectedCategories.isEmpty)
            .onTapGesture {
                clearAction()
            }
    }
}

#Preview {
    @State var testCategories: [String] = ["Category1", "Category2"]
    return AnimatedClearIcon(selectedCategories: $testCategories) {  
        testCategories.removeAll()  
    }
}
