//
//  TimerUtility.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 27/11/24.
//

import Foundation
import Combine

class TimerUtility {
    private var timer: AnyCancellable?
    
    /// Creates and starts a timer that publishes at specified intervals
    /// - Parameters:
    ///   - interval: Time interval between timer events in seconds
    ///   - onTick: Callback closure executed on each timer tick
    /// - Returns: AnyCancellable timer subscription
    static func startTimer(interval: TimeInterval, onTick: @escaping () -> Void) -> AnyCancellable {
        return Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                onTick()
            }
    }
    
    /// Cancels an existing timer
    /// - Parameter timer: The timer to cancel
    static func cancelTimer(_ timer: inout AnyCancellable?) {
        timer?.cancel()
        timer = nil
    }
}
