//
//  Library.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/31/21.
//

import Foundation
import SwiftUI

struct Library: Identifiable, Codable {
    let id: UUID
    var name: String
    var color: Color
    var games: [TabletopGame]
    
    init(id: UUID = UUID(), name: String = "", color: Color = Color.random, games: [TabletopGame] = []) {
        self.id = id
        self.name = name
        self.color = color
        self.games = games
    }
}

extension Library {
    static var data: [Library] {
        [
            Library(name: "Home", color: Color.green, games: TabletopGame.data),
            Library(name: "The Schierleanes", color: Color.blue, games: TabletopGame.data)
        ]
    }
}
