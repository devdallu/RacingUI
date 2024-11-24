//
//  RaceError.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 22/11/24.
//

import Foundation

/// Enum representing different errors that can occur during race fetching.
enum RaceError: LocalizedError {
    case network(underlying: Error)
    case parsing(String)
    case invalidData
    case serverError(Int)
    
    // MARK: - LocalizedError Conformance
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .parsing(let message):
            return "Failed to parse data: \(message)"
        case .invalidData:
            return "Invalid data received"
        case .serverError(let code):
            return "Server error: \(code)"
        }
    }
}
