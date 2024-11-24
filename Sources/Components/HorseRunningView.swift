//
//  File.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 22/11/24.
//

import Foundation
import SwiftUI

struct HorseRunningView: View {
    @State private var isRunning = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: UIImage(named: "horse", in: .module, with: nil) ?? UIImage(named: "heart")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
                    .foregroundColor(.brown)
                    .offset(x: isRunning ? geometry.size.width : -geometry.size.width)
                    .animation(
                        Animation.linear(duration: 3)
                            .repeatForever(autoreverses: false),
                        value: isRunning
                    )
            }
            .onAppear {
                isRunning = true
            }
        }.frame(height: 100)
    }
}

#Preview {
    HorseRunningView()
}
