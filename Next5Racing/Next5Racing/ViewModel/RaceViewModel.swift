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
    // MARK: - Published Properties
    
    @Published private(set) var viewState: RaceViewState = .loading
    @Published private(set) var races: [RaceSummary] = []
    @Published var selectedCategories: [String] = []
    
    // MARK: - Private Properties
    
    private let raceService: RaceServiceProtocol
    private var refreshTask: Task<Void, Never>?
    private var autoRefreshTimer: AnyCancellable?
    private var raceCheckTimer: AnyCancellable?
    private var lastFetchTime: Date?
    private let networkManager: NetworkManager
    
    // MARK: - Initialization
    
    init(raceService: RaceServiceProtocol = RaceService(), networkManager: NetworkManager = NetworkManager()) {
        self.raceService = raceService
        self.networkManager = networkManager
        getRaces()
        setupAutoRefresh()
        setupRaceCheckTimer()
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
        raceCheckTimer?.cancel()
    }
    
}

// MARK: - Timer Setup Extension

private extension RaceViewModel {
    /// Sets up an auto-refresh timer that triggers every 30 seconds
    private func setupAutoRefresh() {
        // Set up a timer that publishes every 30 seconds
        autoRefreshTimer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.getRaces()
            }
    }
    
    /// Sets up a timer to check for and remove expired races every second
    private func setupRaceCheckTimer() {
        raceCheckTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.removeExpiredRaces()
            }
    }
}

// MARK: - Race Data Management Extension
extension RaceViewModel {
    /// Removes races that have been started for 60 seconds or more
    func removeExpiredRaces() {
        let currentTime = Int(Date().timeIntervalSince1970)
        let expiredRaces = races.filter { raceSummary in
            guard let advertisedStart = raceSummary.advertisedStart?.seconds else { return false }
            return currentTime - advertisedStart >= 60
        }
        // If any race expired, fetch new races
        if !expiredRaces.isEmpty {
            getRaces()
        }
        if races.isEmpty {
            viewState = .empty
        }
    }
    
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
                    let timeSinceStart = currentTime - advertisedStart
                    // Only exclude if EXACTLY 60 seconds or more have passed
                    guard timeSinceStart <= 60 else { return nil }
                    if selectedCategories.isEmpty || selectedCategories.contains(raceSummary.categoryID ?? "") {
                        return raceSummary
                    }
                    return nil
                }
                .sorted { ($0.advertisedStart?.seconds ?? 0) < ($1.advertisedStart?.seconds ?? 0) }
                .prefix(5)
            
            let finalRaces = Array(newRaces ?? [])
            
            if finalRaces.isEmpty {
                self.viewState = .empty
            } else {
                self.viewState = .loaded(finalRaces)
            }
            
            // Only update the races list if there are changes
            if races.map({ $0.raceID }) != finalRaces.map({ $0.raceID }) {
                self.races = finalRaces
                lastFetchTime = .now
            }
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
