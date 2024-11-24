//
//  RaceCategory.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 21/11/24.
//

import Foundation

/// Represents a category of a race.
struct RaceCategory: Identifiable, Equatable {
    var id: String
    var name: String
    var isSelected: Bool
    
    // MARK: - Equatable Conformance
    static func == (lhs: RaceCategory, rhs: RaceCategory) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
