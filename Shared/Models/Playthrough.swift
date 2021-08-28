//
//  Playthrough.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import Foundation
import SwiftUI

struct Playthrough: Identifiable, Codable {
    let id: UUID
    let date: Date
    var lengthInMinutes: Int
    var rating: Rating

    init(id: UUID = UUID(), date: Date = Date(), lengthInMinutes: Int, rating: Rating) {
        self.id = id
        self.date = date
        self.lengthInMinutes = lengthInMinutes
        self.rating = rating
    }
}

class PlaythroughTimer: ObservableObject {
    /// The number of seconds since the beginning of the playthrough.
    @Published var secondsElapsed = 0
    @Published var secondsElapsedLessMinutes = 0
    @Published var minutesElapsed = 0
    /// The number of seconds until average playtime.
    @Published var secondsRemaining = 0

    /// The average playtime length.
    var averagePlayTimeInMinutes: Int

    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var averagePlayTimeInSeconds: Int { averagePlayTimeInMinutes * 60 }
    private var startDate: Date?
    
    /**
     Initialize a new timer. Initializing a time with no arguments creates a PlaythroughTimer with zero length.
     Use `startPlaythrough()` to start the timer.
     
     - Parameters:
        - averagePlayTimeInMinutes: The average playtime length.
     */
    init(averagePlayTimeInMinutes: Int = 0) {
        self.averagePlayTimeInMinutes = averagePlayTimeInMinutes
        secondsRemaining = averagePlayTimeInSeconds
    }
    /// Start the timer.
    func startPlaythrough() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        }
    }
    /// Stop the timer.
    func stopPlaythrough() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }
    
    private func update(secondsElapsed: Int) {
        self.secondsElapsed = secondsElapsed
        secondsRemaining = max(averagePlayTimeInSeconds - self.secondsElapsed, 0)
        self.minutesElapsed = Int((Double(secondsElapsed) / 60).rounded(.towardZero))
        self.secondsElapsedLessMinutes = secondsElapsed - (self.minutesElapsed * 60)

        guard !timerStopped else { return }
    }
    
    /**
     Reset the timer with a new average playtime length
     
     - Parameters:
         - averagePlayTimeInMinutes: The average playtime length.
     */
    func reset(averagePlayTimeInMinutes: Int) {
        self.averagePlayTimeInMinutes = averagePlayTimeInMinutes
        secondsRemaining = averagePlayTimeInSeconds
    }
}

extension Playthrough {
    /// A new `Playthrough` using the average playtime length in the `TabletopGame`.
    var timer: PlaythroughTimer {
        PlaythroughTimer(averagePlayTimeInMinutes: lengthInMinutes)
    }
}

