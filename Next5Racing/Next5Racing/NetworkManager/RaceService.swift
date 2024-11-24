//
//  APIService.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import Foundation
import Combine

/// A service responsible for fetching race data from the API.
class RaceService: RaceServiceProtocol {
    // MARK: - Constants
    
    private let baseURL = "https://api.neds.com.au/rest/v1/racing/"
    private let session: URLSession
    
    // MARK: - Initialization
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    
    /// Fetches the next races from the API.
    /// - Returns: A `Race` object containing race data.
    /// - Throws: `RaceError` in case of network, parsing, or server errors.
    public func fetchRaces() async throws -> Race {
        guard let url = URL(string: "\(baseURL)?method=nextraces&count=10") else {
            throw RaceError.invalidData
        }
        
        do {
            // Perform the API request asynchronously
            let (data, response) = try await session.data(from: url)
            // Ensure the response is an HTTP URL response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RaceError.network(underlying: RaceError.invalidData)
            }
            
            // Check for a successful HTTP response status
            guard (200...299).contains(httpResponse.statusCode) else {
                throw RaceError.serverError(httpResponse.statusCode)
            }
            
            // Decode the response data into the `Race` model
            let decoder = JSONDecoder()
            let race = try decoder.decode(Race.self, from: data)
            
            // Validate the status in the decoded response
            guard race.status == 200 else {
                throw RaceError.serverError(race.status ?? 0)
            }
            
            return race
        } catch let decodingError as DecodingError {
            // Handle specific decoding errors
            throw RaceError.parsing(decodingError.localizedDescription)
        } catch {
            // Handle any other network-related errors
            throw RaceError.network(underlying: error)
        }
    }
}
