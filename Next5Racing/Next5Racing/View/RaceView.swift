//
//  RaceView.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI
import RacingUI
import Combine

/// A view that displays the next 5 upcoming races and allows the user to filter by category.
struct RaceView: View {
    @StateObject private var viewModel = RaceViewModel()
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 16) {
                filterSection
                    .padding(.top, 10)
                Spacer(minLength: 1)
                contentSection
                    .refreshable {
                        await viewModel.fetchRaces()
                    }
                Spacer(minLength: 1)
            }
            .navigationTitle("Next 5 Races")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.getRaces()
            }
        }
    }
    
    // MARK: - Filter Section
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.raceCategories) { category in
                    NRFilterChip(
                        title: category.name,
                        isSelected: category.isSelected
                    ) {
                        viewModel.toggleCategorySelection(for: category)
                    }
                    .accessibilityLabel("\(category.name) races")
                    .accessibilityHint(category.isSelected ? "Selected" : "Not selected")
                }
                AnimatedClearIcon(selectedCategories: .constant(viewModel.selectedCategories)) {
                    viewModel.clearAllSelections()
                }
                .disabled(viewModel.selectedCategories.isEmpty)
                .accessibilityLabel("Clear all filters")
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Content Section
    
    @ViewBuilder
    private var contentSection: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
                .accessibilityLabel("Loading races")
        case .loaded(let races):
            racesList(races)
        case .empty:
            NREmptyStateView(
                title: "No Upcoming Races",
                message: """
                There are currently no races scheduled for the selected categories or time range.
                Please check back later or adjust your filters.
                """,
                icon: "exclamationmark.triangle.fill"
            )
            .accessibilityLabel("No races available")
        case .error(let message):
            NRErrorView(error: message) {
                    viewModel.getRaces()
            }
            .accessibilityLabel("Error: \(message)")
        }
    }
    
    private func racesList(_ races: [RaceSummary]) -> some View {
        List(races, id: \.self) { raceSummary in
            RaceRowView(
                raceSummary: raceSummary,
                categoryImage: viewModel.getCategoryImage(for: raceSummary.categoryID ?? ""),
                onRaceStart: {
                       Task {
                           await viewModel.fetchRaces()
                       }
                   }
            )
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    RaceView()
}
