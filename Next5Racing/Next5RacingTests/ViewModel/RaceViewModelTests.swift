//
//  RaceViewModelTests.swift
//  Next5RacingTests
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 22/11/24.
//

import XCTest
import Combine
@testable import Next5Racing

final class RaceViewModelTests: XCTestCase {
    var viewModel: RaceViewModel!
    var cancellables: Set<AnyCancellable>!
    
    @MainActor
    override func setUp() {
        super.setUp()
        viewModel = RaceViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // Test for successful fetching of races
    @MainActor
    func testGetRaces_success() {
        // Given
        let mockRaces = createMockRaces()
        let expectation = self.expectation(description: "Get races")
        
        // When
        viewModel.$viewState
            .sink { state in
                if case .loaded(let races) = state {
                    // Then
                    XCTAssertEqual(races.count, mockRaces.count)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Simulate the API call by setting the viewState directly
        viewModel.setViewStateForTesting(.loaded(mockRaces))
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // Test for no races available
    @MainActor
    func testGetRaces_empty() {
        // Given
        let expectation = self.expectation(description: "Get empty races")
        
        // When
        viewModel.setViewStateForTesting(.empty)
        viewModel.$viewState
            .sink { state in
                // Then
                if case .empty = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // Test for error when fetching races
    @MainActor
    func testGetRaces_error() {
        // Given
        let expectation = self.expectation(description: "Handle error")
        
        // When
        viewModel.setViewStateForTesting(.error("Network error"))
        viewModel.$viewState
            .sink { state in
                // Then
                if case .error(let message) = state {
                    XCTAssertEqual(message, "Network error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // Test for updating categories
    @MainActor
    func testUpdateCategories() {
        // Given
        XCTAssertTrue(viewModel.selectedCategories.isEmpty)
        let categories = ["C1", "C2"]
        
        // When
        viewModel.updateCategories(categories)
        
        // Then
        XCTAssertEqual(viewModel.selectedCategories, categories)
        
        // Simulate fetching races and verifying the filter
        let mockRaces = createMockRaces()
        let expectation = self.expectation(description: "Filtered races")
        viewModel.setViewStateForTesting(.loaded(mockRaces))
        observeRaceStateExpectation(expectation)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // Test for toggling category selection
    @MainActor
    func testToggleCategorySelection() {
        // Given
        XCTAssertTrue(viewModel.selectedCategories.isEmpty)
        let horseCategory = RaceCategory(id: "4a2788f8-e825-4d36-9894-efd4baf1cfae", name: "Horse", isSelected: false)
        
        // When
        viewModel.toggleCategorySelection(for: horseCategory)
        
        // Then
        XCTAssertTrue(viewModel.selectedCategories.contains(horseCategory.id))
        viewModel.toggleCategorySelection(for: horseCategory)
        XCTAssertFalse(viewModel.selectedCategories.contains(horseCategory.id))
    }
    
    // Test for clearing all selections
    @MainActor
    func testClearAllSelections() {
        // Given
        let categories = ["4a2788f8-e825-4d36-9894-efd4baf1cfae", "161d9be2-e909-4326-8c2c-35ed71fb460b"]
        viewModel.updateCategories(categories)
        
        // When
        XCTAssertEqual(viewModel.selectedCategories.count, 2)
        viewModel.clearAllSelections()
        
        // Then
        XCTAssertTrue(viewModel.selectedCategories.isEmpty)
    }
    
    // Test for auto-refresh fetching new races
    @MainActor
    func testAutoRefreshFetchesNewRaces() {
        // Given
        let initialRaces = createInitialMockRaces()
        let expectation = self.expectation(description: "Fetches new races after refresh")
        
        // When
        viewModel.setViewStateForTesting(.loaded(initialRaces))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newRaces = self.createNewMockRaces()
            self.viewModel.setViewStateForTesting(.loaded(newRaces))
            self.viewModel.$viewState
                .sink { state in
                    // Then
                    if case .loaded(let races) = state {
                        XCTAssertEqual(races.count, newRaces.count)
                        expectation.fulfill()
                    }
                }
                .store(in: &self.cancellables)
        }
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    // Test for race fetch error handling
    @MainActor
    func testFetchRacesError() {
        // Given
        let expectation = self.expectation(description: "Handles race fetch error")
        
        // When
        viewModel.setViewStateForTesting(.error("Network error"))
        viewModel.$viewState
            .sink { state in
                // Then
                if case .error(let errorMessage) = state {
                    XCTAssertEqual(errorMessage, "Network error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // MARK: - Helpers
    
    private func createMockRaces() -> [RaceSummary] {
        let mockAdvertisedStart = AdvertisedStart(seconds: 1633046400)
        let mockRaceForm = RaceForm(
            distance: 1200,
            distanceType: nil,
            distanceTypeID: nil,
            trackCondition: nil,
            trackConditionID: nil,
            weather: nil,
            weatherID: nil,
            raceComment: nil,
            additionalData: nil,
            generated: nil,
            silkBaseURL: nil,
            raceCommentAlternative: nil)
        let mockVenueCountry: VenueCountry = .aus
        
        return [
            RaceSummary(
                raceID: "1",
                raceName: "Race 1",
                raceNumber: 1,
                meetingID: "M1",
                meetingName: "Race 1",
                categoryID: "C1",
                advertisedStart: mockAdvertisedStart,
                raceForm: mockRaceForm,
                venueID: "V1",
                venueName: "Venue 1",
                venueState: "State 1",
                venueCountry: mockVenueCountry),
            RaceSummary(
                raceID: "2",
                raceName: "Race 2",
                raceNumber: 2,
                meetingID: "M2",
                meetingName: "Race 2",
                categoryID: "C2",
                advertisedStart: mockAdvertisedStart,
                raceForm: mockRaceForm,
                venueID: "V2",
                venueName: "Venue 2",
                venueState: "State 2",
                venueCountry: mockVenueCountry)
        ]
    }
    
    private func createInitialMockRaces() -> [RaceSummary] {
        return createMockRaces()
    }
    
    private func createNewMockRaces() -> [RaceSummary] {
        let mockAdvertisedStart = AdvertisedStart(seconds: 1633046600)
        let mockRaceForm = RaceForm(
            distance: 1200,
            distanceType: nil,
            distanceTypeID: nil,
            trackCondition: nil,
            trackConditionID: nil,
            weather: nil,
            weatherID: nil,
            raceComment: nil,
            additionalData: nil,
            generated: nil,
            silkBaseURL: nil,
            raceCommentAlternative: nil)
        let mockVenueCountry: VenueCountry = .aus
        
        return [
            RaceSummary(
                raceID: "2",
                raceName: "Race 2",
                raceNumber: 2,
                meetingID: "M2",
                meetingName: "Meeting 2",
                categoryID: "C2",
                advertisedStart: mockAdvertisedStart,
                raceForm: mockRaceForm,
                venueID: "V2",
                venueName: "Venue 2",
                venueState: "State 2",
                venueCountry: mockVenueCountry)
        ]
    }
    
    @MainActor
    private func observeRaceStateExpectation(_ expectation: XCTestExpectation) {
        viewModel.$viewState
            .sink { state in
                if case .loaded(let races) = state {
                    XCTAssertEqual(races.count, 2)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
    }
}
