//
//  RaceRowViewModel.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 23/11/24.
//

import Foundation
import Combine

class RaceRowViewModel: ObservableObject {
    // MARK: - Constants
    
    enum RaceConstants {
        static let raceStartedThreshold: Int = -60
        static let timerInterval: TimeInterval = 1
        static let secondsInAMinute: Int = 60
    }
    // MARK: - Properties
    
    let raceSummary: RaceSummary
    private var timer: AnyCancellable?
    var onRaceStart: (() -> Void)?
    
    @Published private(set) var remainingTime: Int?
    
    // MARK: - Initialization
    
    /// Initializes a new race row view model
    @MainActor
    init(raceSummary: RaceSummary, onRaceStart: (() -> Void)? = nil) {
        self.raceSummary = raceSummary
        self.onRaceStart = onRaceStart
        if let advertisedStart = raceSummary.advertisedStart?.seconds {
            self.remainingTime = advertisedStart - Int(Date().timeIntervalSince1970)
        }
        setupTimer()
    }
}
// MARK: - Timer Management
extension RaceRowViewModel {
    /// Sets up the timer to update the remaining time every second
    @MainActor
    private func setupTimer() {
        if timer == nil {
            timer = TimerUtility.startTimer(interval: RaceConstants.timerInterval) { [weak self] in
                self?.updateRemainingTime()
            }
        }
    }
    
    /// Updates the remaining time until race start
    @MainActor
    func updateRemainingTime() {
        if let advertisedStart = raceSummary.advertisedStart?.seconds {
            remainingTime = advertisedStart - Int(Date().timeIntervalSince1970)
            if remainingTime ?? 0 <= RaceConstants.raceStartedThreshold {
                timer?.cancel()
                TimerUtility.cancelTimer(&timer)
                onRaceStart?()
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
            let minutes = remainingTime / RaceConstants.secondsInAMinute
            let seconds = remainingTime % RaceConstants.secondsInAMinute
            return "\(minutes) min \(seconds)s"
        } else {
            let elapsedSeconds = abs(remainingTime)
            if elapsedSeconds < RaceConstants.secondsInAMinute {
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
