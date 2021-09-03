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
    var maximumPlayTime: Double
    var playthroughState: PlaythroughState = .allGames

    init(id: UUID = UUID(), numberOfPlayers: Double, minimumRating: Double, maximumPlayTime: Double, playthroughState: PlaythroughState) {
        self.id = id
        self.numberOfPlayers = numberOfPlayers
        self.minimumRating = minimumRating
        self.maximumPlayTime = maximumPlayTime
        self.playthroughState = playthroughState
    }
    
    func filterGameOptions(allGames: [TabletopGame]) -> [TabletopGame] {
        let gameOptions = allGames.filter({(game:TabletopGame) -> Bool in
            return (game.minimumPlayers <= Int(self.numberOfPlayers) && game.maximumPlayers >= Int(self.numberOfPlayers))
                && game.rating.rating >= self.minimumRating
                && game.lengthInMinutes <= Int(self.maximumPlayTime)
                && isPlaythroughStateMatched(game.playthrough)
        })
        
        return gameOptions
    }
    
    func isPlaythroughStateMatched(_ playthroughs: [Playthrough]) -> Bool {
        if (self.playthroughState == .allGames) { return true }
        
        if (self.playthroughState == .newGamesOnly && playthroughs.count == 0) { return true }
        
        if (self.playthroughState == .playedGamesOnly && playthroughs.count > 0) { return true }
        
        return false
    }
}

enum PlaythroughState: String, Codable {
    case newGamesOnly, playedGamesOnly, allGames
}
