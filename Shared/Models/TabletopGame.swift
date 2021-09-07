//
//  TabletopGame.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

struct TabletopGame: Identifiable, Codable {
    let id: UUID
    var title: String
    var typeIsBase: Bool
    var typeIsExpansion: Bool
    var typeIsVariant: Bool
    var minimumPlayers: Int
    var maximumPlayers: Int
    var lengthInMinutes: Int
    var color: Color
    var rating: Rating
    var baseGameID: UUID?
    //var image: Image
    var imageURLString: String
    //var categories: [String]
    var playthroughs: [Playthrough]
    //var comments: [Comments]
    var dummy: Bool = false
    
    init(id: UUID = UUID(),
         title: String = "",
         typeIsBase: Bool = true,
         typeIsExpansion: Bool = false,
         typeIsVariant: Bool = false,
         minimumPlayers: Int = 1,
         maximumPlayers: Int = 20,
         lengthInMinutes: Int = 60,
         color: Color = Color.random,
         rating: Rating = Rating(0),
         baseGameID: UUID? = nil,
         imageURLString: String = "",
         playthroughs: [Playthrough] = []) {
        self.id = id
        self.title = title
        self.typeIsBase = typeIsBase
        self.typeIsExpansion = typeIsExpansion
        self.typeIsVariant = typeIsVariant
        self.minimumPlayers = minimumPlayers
        self.maximumPlayers = maximumPlayers
        self.lengthInMinutes = lengthInMinutes
        self.color = color
        self.rating = rating
        self.baseGameID = baseGameID
        self.imageURLString = imageURLString
        self.playthroughs = playthroughs
    }
    
    func imageURL() -> URL {
        return URL(string: self.imageURLString)!
    }
    
    mutating func recalculateRating() {
        rating = Rating(playthroughs.reduce(0) { ($0 + $1.rating.rating) } / Double(playthroughs.count))
    }
    
    mutating func updateDetails(_ game: TabletopGame) {
        self.title = game.title
        self.typeIsBase = game.typeIsBase
        self.typeIsExpansion = game.typeIsExpansion
        self.typeIsVariant = game.typeIsVariant
        self.minimumPlayers = game.minimumPlayers
        self.maximumPlayers = game.maximumPlayers
        self.lengthInMinutes = game.lengthInMinutes
        self.color = game.color
        self.rating = game.rating
        self.baseGameID = game.baseGameID
        self.imageURLString = game.imageURLString
        self.playthroughs = game.playthroughs
    }
}

extension TabletopGame {
    static var data: [TabletopGame] {
        [
            TabletopGame(title: "Clue",
                         minimumPlayers: 3,
                         maximumPlayers: 6,
                         lengthInMinutes: 60,
                         color: Color.blue,
                         rating: Rating(1)),
            TabletopGame(title: "Clue, The Legend of Zelda Edition",
                         typeIsBase: false,
                         typeIsVariant: true,
                         minimumPlayers: 3,
                         maximumPlayers: 6,
                         lengthInMinutes: 60,
                         color: Color.green,
                         rating: Rating(2)),
            TabletopGame(title: "Villainous",
                         minimumPlayers: 2,
                         maximumPlayers: 6,
                         lengthInMinutes: 90,
                         color: Color.purple,
                         rating: Rating(5),
                         imageURLString:  "https://cf.geekdo-images.com/7Ej5V5Dq92QdvVFvISfl_A__original/img/XHykA7cqZ0F4tYiKXw095TvHRno=/0x0/filters:format(jpeg)/pic4216110.jpg"),
            TabletopGame(title: "Villainous: Pride",
                         typeIsBase: false,
                         typeIsExpansion: true,
                         typeIsVariant: true,
                         minimumPlayers: 2,
                         maximumPlayers: 6,
                         lengthInMinutes: 90,
                         color: Color.purple,
                         rating: Rating(5))
        ]
    }
    
    static var data2: [TabletopGame] {
        [
            TabletopGame(title: "Trouble",
                         minimumPlayers: 2,
                         maximumPlayers: 4,
                         lengthInMinutes: 30,
                         color: Color.yellow,
                         rating: Rating(1)),
            TabletopGame(title: "Hoot!",
                         minimumPlayers: 2,
                         maximumPlayers: 4,
                         lengthInMinutes: 30,
                         color: Color.blue,
                         rating: Rating(2))
        ]
    }
}

extension TabletopGame {
    struct Data {
        var title: String = ""
        var typeIsBase: Bool = true
        var typeIsExpansion: Bool = false
        var typeIsVariant: Bool = false
        var minimumPlayers: Double = 1
        var maximumPlayers: Double = 5
        var lengthInMinutes: Double = 5.0
        var color: Color = .random
        var baseGameID: UUID?
        var imageURLString: String = ""
        var rating: Rating = Rating(0)
    }
    
    var data: Data {
        return Data(title: title,
                    typeIsBase: typeIsBase,
                    typeIsExpansion: typeIsExpansion,
                    typeIsVariant: typeIsVariant,
                    minimumPlayers: Double(minimumPlayers),
                    maximumPlayers: Double(maximumPlayers),
                    lengthInMinutes: Double(lengthInMinutes),
                    color: color,
                    baseGameID: baseGameID,
                    imageURLString: imageURLString,
                    rating: rating)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        typeIsBase = data.typeIsBase
        typeIsExpansion = data.typeIsExpansion
        typeIsVariant = data.typeIsVariant
        minimumPlayers = Int(data.minimumPlayers)
        maximumPlayers = Int(data.maximumPlayers)
        lengthInMinutes = Int(data.lengthInMinutes)
        color = data.color
        baseGameID = data.baseGameID
        imageURLString = data.imageURLString
        rating = data.rating
    }
}
