//
//  RaceState.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 22/11/24.
//

import Foundation

// MARK: - ViewState.swif
enum RaceViewState: Equatable {
    case loading
    case loaded([RaceSummary])
    case error(String)
    case empty
}
