//
//  Filter.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/24/21.
//

import Foundation

struct Filter: Identifiable, Codable {
    let id: UUID
    var numberOfPlayers: Double
    var minimumRating: Double

    init(id: UUID = UUID(), numberOfPlayers: Double, minimumRating: Double) {
        self.id = id
        self.numberOfPlayers = numberOfPlayers
        self.minimumRating = minimumRating
    }
}
