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
    var title: String
    var color: Color
    var games: [TabletopGame]
    var dummy: Bool = false
    var selectedGame: TabletopGame?
    
    init(id: UUID = UUID(), title: String = "", color: Color = Color.random, games: [TabletopGame] = [], dummy: Bool = false) {
        self.id = id
        self.title = title
        self.color = color
        self.games = games
        self.dummy = dummy
    }
    
    mutating func updateDetails(_ lib: Library) {
        self.title = lib.title
        self.color = lib.color
        self.games = lib.games
    }
    
    func getGameIndex(game: TabletopGame) -> Int {
        guard let gameIndex = self.games.firstIndex(where: { $0.id == game.id }) else {
            fatalError("Can't find game in array")
        }
        return gameIndex
    }
}

extension Library {
    static var data: [Library] {
        [
            Library(title: "Home", color: Color.green, games: TabletopGame.data),
            Library(title: "Kids", color: Color.blue, games: TabletopGame.data2)
        ]
    }
}
