//
//  RaceRowView.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 22/11/24.
//

import SwiftUI
import RacingUI

/// A view displaying individual race details within a list.
struct RaceRowView: View {
    @StateObject private var viewModel: RaceRowViewModel
    private let categoryImage: String
    
    init(raceSummary: RaceSummary, categoryImage: String) {
        self._viewModel = StateObject(wrappedValue: RaceRowViewModel(raceSummary: raceSummary))
        self.categoryImage = categoryImage
    }
    
    var body: some View {
        HStack {
            NRRowView(
                raceName: viewModel.raceSummary.meetingName,
                raceNumber: viewModel.raceSummary.raceNumber,
                startTime: viewModel.raceCountdownText(),
                raceImage: categoryImage
            )
            .listRowSeparator(.hidden)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(viewModel.accessibilityLabel)
        }
        .font(.body)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    RaceView()
}
