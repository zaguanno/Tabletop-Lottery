//
//  GameData.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import Foundation

class GameData: ObservableObject {
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("game.data")
    }
    @Published var games: [TabletopGame] = []
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.games = TabletopGame.data
                }
                #endif
                return
            }
            guard let tabletopGames = try? JSONDecoder().decode([TabletopGame].self, from: data) else {
                fatalError("Can't decode saved game data.")
            }
            DispatchQueue.main.async {
                self?.games = tabletopGames
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let games = self?.games else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(games) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}
