//
//  RaceRowViewModelTests.swift
//  Next5RacingTests
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 23/11/24.
//

import XCTest
@testable import Next5Racing
import Combine

final class RaceRowViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    @MainActor func testInitialization() {
        // Given
        let raceSummary = createMockRaceSummary()
        
        // When
        let viewModel = RaceRowViewModel(raceSummary: raceSummary)
        
        // Then
        XCTAssertNotNil(viewModel.remainingTime)
        XCTAssertEqual(viewModel.raceSummary.meetingName, "Meeting 1")
        XCTAssertEqual(viewModel.raceSummary.raceNumber, 1)
    }
    
    @MainActor func testRaceCountdownText_FutureRace() {
        // Given
        let futureTime = Int(Date().timeIntervalSince1970) + 125 // 2 minutes and 5 seconds from now
        let raceSummary = createMockRaceSummary(withStartTime: futureTime)
        
        // When
        let viewModel = RaceRowViewModel(raceSummary: raceSummary)
        
        // Then
        XCTAssertEqual(viewModel.raceCountdownText(), "2 min 5s")
    }
    
    @MainActor func testRaceCountdownText_JustStartedRace() {
        // Given
        let pastTime = Int(Date().timeIntervalSince1970) - 30 // 30 seconds ago
        let raceSummary = createMockRaceSummary(withStartTime: pastTime)
        
        // When
        let viewModel = RaceRowViewModel(raceSummary: raceSummary)
        
        // Then
        XCTAssertEqual(viewModel.raceCountdownText(), "-30s")
    }
    
    @MainActor func testRaceCountdownText_StartedRace() {
        // Given
        let pastTime = Int(Date().timeIntervalSince1970) - 61 // 61 seconds ago
        let raceSummary = createMockRaceSummary(withStartTime: pastTime)
        
        // When
        let viewModel = RaceRowViewModel(raceSummary: raceSummary)
        
        // Then
        XCTAssertEqual(viewModel.raceCountdownText(), "Race Started!")
    }
    
    @MainActor func testRaceCountdownText_NoStartTime() {
        // Given
        let raceSummary = createMockRaceSummary(withStartTime: nil)
        
        // When
        let viewModel = RaceRowViewModel(raceSummary: raceSummary)
        
        // Then
        XCTAssertEqual(viewModel.raceCountdownText(), "Time unknown")
    }
    
    @MainActor func testAccessibilityLabel() {
        // Given
        let futureTime = Int(Date().timeIntervalSince1970) + 300 // 5 minutes from now
        let raceSummary = createMockRaceSummary(withStartTime: futureTime)
        
        // When
        let viewModel = RaceRowViewModel(raceSummary: raceSummary)
        let accessibilityLabel = viewModel.accessibilityLabel
        
        // Then
        XCTAssertTrue(accessibilityLabel.contains("Race 1"))
        XCTAssertTrue(accessibilityLabel.contains("at Meeting 1"))
        XCTAssertTrue(accessibilityLabel.contains("starting in"))
    }
    
    @MainActor func testTimerUpdatesRemainingTime() {
        // Given
        let expectation = XCTestExpectation(description: "Timer updates")
        let futureTime = Int(Date().timeIntervalSince1970) + 5 // 5 seconds from now
        let raceSummary = createMockRaceSummary(withStartTime: futureTime)
        let viewModel = RaceRowViewModel(raceSummary: raceSummary)
        let initialRemainingTime = viewModel.remainingTime
        
        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            // Then
            XCTAssertNotNil(initialRemainingTime)
            XCTAssertNotEqual(viewModel.remainingTime, initialRemainingTime)
            XCTAssertEqual(viewModel.remainingTime, initialRemainingTime! - 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    // MARK: - Helpers
    
    private func createMockRaceSummary(withStartTime seconds: Int? = 1633046400) -> RaceSummary {
        let mockAdvertisedStart = seconds.map { AdvertisedStart(seconds: $0) }
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
        
        return RaceSummary(
            raceID: "1",
            raceName: "Race 1",
            raceNumber: 1,
            meetingID: "M1",
            meetingName: "Meeting 1",
            categoryID: "C1",
            advertisedStart: mockAdvertisedStart,
            raceForm: mockRaceForm,
            venueID: "V1",
            venueName: "Venue 1",
            venueState: "State 1",
            venueCountry: .aus)
    }
}
