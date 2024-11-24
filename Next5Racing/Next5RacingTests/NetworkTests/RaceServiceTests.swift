//
//  RaceServiceTests.swift
//  Next5RacingTests
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 24/11/24.
//

import Foundation
import XCTest
@testable import Next5Racing

final class RaceServiceTests: XCTestCase {
    var raceService: RaceService!
    var session: URLSession!
    let baseURL = "https://api.neds.com.au/rest/v1/racing/"
    
    override func setUp() {
        super.setUp()
        
        // Configure URLSession with mock protocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        
        // Initialize RaceService with mock session
        raceService = RaceService(session: session)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        session = nil
        raceService = nil
        super.tearDown()
    }
    
    func testFetchRaces_Success() async throws {
        // Given
        let expectedRace = createMockRace()
        let jsonData = try JSONEncoder().encode(expectedRace)
        
        // Ensure we're handling the exact URL we expect
        let expectedURLString = "\(baseURL)?method=nextraces&count=10"
        guard let expectedURL = URL(string: expectedURLString) else {
            XCTFail("Failed to create expected URL")
            return
        }
        
        MockURLProtocol.requestHandler = { request in
            // Verify the request URL matches what we expect
            XCTAssertEqual(request.url?.absoluteString, expectedURL.absoluteString)
            
            let response = HTTPURLResponse(
                url: expectedURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, jsonData)
        }
        
        // When
        let result = try await raceService.fetchRaces()
        
        // Then
        XCTAssertEqual(result.status, expectedRace.status)
        XCTAssertEqual(result.message, expectedRace.message)
        XCTAssertEqual(result.data?.nextToGoIDS?.count, expectedRace.data?.nextToGoIDS?.count)
    }
    
    // MARK: - Helpers
    
    private func createMockRace() -> Race {
        let raceSummary = RaceSummary(
            raceID: "1",
            raceName: "Test Race",
            raceNumber: 1,
            meetingID: "M1",
            meetingName: "Test Meeting",
            categoryID: "C1",
            advertisedStart: AdvertisedStart(seconds: 1633046400),
            raceForm: RaceForm(
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
                raceCommentAlternative: nil
            ),
            venueID: "V1",
            venueName: "Test Venue",
            venueState: "Test State",
            venueCountry: .aus
        )
        
        let dataClass = DataClass(
            nextToGoIDS: ["1"],
            raceSummaries: ["1": raceSummary]
        )
        
        return Race(
            status: 200,
            data: dataClass,
            message: "Success"
        )
    }
}
