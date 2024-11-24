//
//  RaceProtocol.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 22/11/24.
//

import Foundation

/// Protocol for the RaceService to ensure mockability for testing.
protocol RaceServiceProtocol {
    func fetchRaces() async throws -> Race
}
