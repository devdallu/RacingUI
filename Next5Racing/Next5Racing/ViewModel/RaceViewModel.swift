//
//  RaceViewModel.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import SwiftUI
import Combine

/// The ViewModel responsible for managing race data and business logic for the RaceView.
@MainActor
class RaceViewModel: ObservableObject {
    // MARK: - Constants
    
    enum RaceConstants {
        static let raceAutoRefreshInterval: TimeInterval = 60
        static let raceStartedThreshold: Int = -60
        static let raceListLimit: Int = 5
    }
    // MARK: - Published Properties
    
    @Published private(set) var viewState: RaceViewState = .loading
    @Published private(set) var races: [RaceSummary] = []
    @Published var selectedCategories: [String] = []
    
    // MARK: - Private Properties
    
    private let raceService: RaceServiceProtocol
    private var refreshTask: Task<Void, Never>?
    private var autoRefreshTimer: AnyCancellable?
    private let networkManager: NetworkManager
    
    // MARK: - Initialization
    
    init(raceService: RaceServiceProtocol = RaceService(), networkManager: NetworkManager = NetworkManager()) {
        self.raceService = raceService
        self.networkManager = networkManager
        setupAutoRefresh()
    }
    
    // MARK: - Public Methods
    
    /// Fetch races from the service.
    func getRaces() {
        refreshTask?.cancel()
        refreshTask = Task {
            await fetchRaces()
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        refreshTask?.cancel()
        autoRefreshTimer?.cancel()
    }
    
}

// MARK: - Timer Setup Extension

private extension RaceViewModel {
    /// Sets up an auto-refresh timer that triggers every 60 seconds
    private func setupAutoRefresh() {
        // Set up a timer that publishes every 60 seconds
        autoRefreshTimer = Timer.publish(every: RaceConstants.raceAutoRefreshInterval, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.getRaces()
            }
    }
}

// MARK: - Race Data Management Extension
extension RaceViewModel {
    /// Fetches races from the service and updates the view state accordingly
    /// - Handles network connectivity checks
    /// - Filters races based on selected categories
    /// - Sorts races by start time
    /// - Updates view state based on results
    func fetchRaces() async {
        
        // Check network connectivity before proceeding
        if !networkManager.isConnected {
            viewState = .error("No internet connection.")
            return
        }
        
        if races.isEmpty {
            viewState = .loading
        }
        do {
            let race = try await raceService.fetchRaces()
            guard let raceData = race.data else {
                viewState = .error("No race data available")
                return
            }
            
            let currentTime = Int(Date().timeIntervalSince1970)
            let newRaces = raceData.raceSummaries?.values
                .compactMap { raceSummary -> RaceSummary? in
                    guard let advertisedStart = raceSummary.advertisedStart?.seconds else { return nil }
                    // Calculate exact time since start
                    let timeUntilStart = advertisedStart - currentTime
                    // Filter out races that are 60 seconds or more past start
                    guard timeUntilStart > RaceConstants.raceStartedThreshold else { return nil }
                    if selectedCategories.isEmpty || selectedCategories.contains(raceSummary.categoryID ?? "") {
                        return raceSummary
                    }
                    return nil
                }
                .sorted { race1, race2 in
                    let time1 = (race1.advertisedStart?.seconds ?? 0) - currentTime
                    let time2 = (race2.advertisedStart?.seconds ?? 0) - currentTime
                    return time1 < time2
                }
                .prefix(RaceConstants.raceListLimit)
            
            let finalRaces = Array(newRaces ?? [])
            
            if finalRaces.isEmpty {
                self.viewState = .empty
            } else {
                self.viewState = .loaded(finalRaces)
            }
            self.races = finalRaces
        } catch {
            if error is CancellationError { return }
            viewState = .error(error.localizedDescription)
        }
    }
}

// MARK: - Category Management Extension
extension RaceViewModel {
    /// Updates the selected category filters and refreshes race data
    func updateCategories(_ categories: [String]) {
        selectedCategories = categories
        getRaces()
    }
    
    /// Clears all category filters
    func clearAllSelections() {
        updateCategories([])
    }
    
    /// Toggles the selection state of a specific category
    func toggleCategorySelection(for category: RaceCategory) {
        if let index = selectedCategories.firstIndex(of: category.id) {
            selectedCategories.remove(at: index)
        } else {
            selectedCategories.append(category.id)
        }
        updateCategories(selectedCategories)
    }
    
    /// Returns the appropriate image name for a given category ID
    func getCategoryImage(for categoryId: String) -> String {
        switch categoryId {
        case "4a2788f8-e825-4d36-9894-efd4baf1cfae":
            return "horse"
        case "161d9be2-e909-4326-8c2c-35ed71fb460b":
            return "harness"
        case "9daef0d7-bf3c-4f50-921d-8e818c60fe61":
            return "greyhound"
        default:
            return "questionmark.circle"
        }
    }
    
    /// Available race categories with their selection states
    var raceCategories: [RaceCategory] {
        [
            RaceCategory(
                id: "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                name: "Horse",
                isSelected: selectedCategories.contains("4a2788f8-e825-4d36-9894-efd4baf1cfae")
            ),
            RaceCategory(
                id: "161d9be2-e909-4326-8c2c-35ed71fb460b",
                name: "Harness",
                isSelected: selectedCategories.contains("161d9be2-e909-4326-8c2c-35ed71fb460b")
            ),
            RaceCategory(
                id: "9daef0d7-bf3c-4f50-921d-8e818c60fe61",
                name: "Greyhound",
                isSelected: selectedCategories.contains("9daef0d7-bf3c-4f50-921d-8e818c60fe61")
            )
        ]
    }
}

// MARK: - Testing Support Extension
extension RaceViewModel {
    /// Sets the view state directly for testing purposes
    /// - Parameter state: The desired view state
    func setViewStateForTesting(_ state: RaceViewState) {
        self.viewState = state
    }
}
