//
//  SwiftUIView.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI

public struct NRRowView: View {
    
    private let raceName: String
    private let raceNumber: Int
    private let startTime:String
    private let raceImage:String
    
    @State private var animationScale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    
    public init(
        raceName: String?,
        raceNumber: Int?,
        startTime: String?,
        raceImage: String?
    ) {
        self.raceName = raceName ?? "Unknown Race"
        self.raceNumber = raceNumber ?? 0
        self.startTime = startTime ?? "00:00"
        self.raceImage = raceImage ?? "heart"
    }
    
    public var body: some View {
        NRCard {
            HStack {
                VStack(alignment:.leading) {
                    Image(uiImage: UIImage(named: raceImage, in: .module, with: nil) ?? UIImage(named: "heart")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .scaleEffect(animationScale)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animationScale)
                    HStack {
                        Text(raceName)
                            .font(.headline)
                            .dynamicTypeSize(.large)
                            .lineLimit(1)
                            .transition(.slide)
                        Text("R\(raceNumber)")
                            .font(.headline)
                            .lineLimit(1)
                            .dynamicTypeSize(.large)
                            .transition(.move(edge: .bottom))
                    }
                }
                
                Spacer()
                Text(startTime)
                    .font(.headline)
                    .foregroundStyle(.red)
                    .dynamicTypeSize(.large)
                    .opacity(opacity)
            }
        }
        .padding(4)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animationScale = 1.1
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    animationScale = 1.0
                }
            }
        }
        .animation(.smooth, value: animationScale)
    }
}

#Preview(body: {
    NRRowView(
        raceName: "Grand Prix Grand Prix Grand Prix Grand PrixGrand PrixGrand PrixGrand PrixGrand Prix",
        raceNumber: 1,
        startTime: "3m 40s",
        raceImage: "horse"
    )
    NRRowView(
        raceName: "Grand Prix",
        raceNumber: 1,
        startTime: "3m 40s",
        raceImage: "horse"
    )
    NRRowView(
        raceName: "Grand Prix",
        raceNumber: 1,
        startTime: "3m 40s",
        raceImage: "horse"
    )
})
