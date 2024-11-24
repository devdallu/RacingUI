//
//  RaceRowViewModel.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 23/11/24.
//

import Foundation
import Combine

class RaceRowViewModel: ObservableObject {
    // MARK: - Properties
    
    let raceSummary: RaceSummary
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var remainingTime: Int?
    
    // MARK: - Initialization
    
    /// Initializes a new race row view model
    @MainActor
    init(raceSummary: RaceSummary) {
        self.raceSummary = raceSummary
        if let advertisedStart = raceSummary.advertisedStart?.seconds {
            self.remainingTime = advertisedStart - Int(Date().timeIntervalSince1970)
        }
        setupTimer()
    }
}
// MARK: - Timer Management
private extension RaceRowViewModel {
    /// Sets up the timer to update the remaining time every second
    @MainActor
    private func setupTimer() {
        if timer == nil {
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                .sink { [weak self] _ in
                    self?.updateRemainingTime()
                }
        }
    }
    
    /// Updates the remaining time until race start
    @MainActor
    private func updateRemainingTime() {
        if let advertisedStart = raceSummary.advertisedStart?.seconds {
            remainingTime = advertisedStart - Int(Date().timeIntervalSince1970)
            if remainingTime ?? 0 == -60 {
                timer?.cancel()
            }
        }
    }
}

// MARK: - Display Formatting
extension RaceRowViewModel {
    /// Formats the remaining time into a human-readable string
    func raceCountdownText() -> String {
        guard let remainingTime = remainingTime else { return "Time unknown" }
        if remainingTime > 0 {
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            return "\(minutes) min \(seconds)s"
        } else {
            let elapsedSeconds = abs(remainingTime)
            if elapsedSeconds < 60 {
                return "-\(elapsedSeconds)s"
            } else {
                return "Race Started!"
            }
        }
    }
}

// MARK: - Accessibility
extension RaceRowViewModel {
    var accessibilityLabel: String {
        let location = raceSummary.meetingName ?? "Unknown location"
        let raceNumber = raceSummary.raceNumber.map { String($0) } ?? "Unknown"
        let timeText = raceCountdownText()
        return "Race \(raceNumber) at \(location), starting in \(timeText)"
    }
}
