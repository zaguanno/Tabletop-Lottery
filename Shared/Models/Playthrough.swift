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
