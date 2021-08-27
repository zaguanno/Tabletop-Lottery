//
//  Filter.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/24/21.
//

import SwiftUI
import XMLCoder

class ScanResult: Identifiable, Codable {
    var id = UUID()
    
    var rawAPIResult: [[String]] = []
    var rawScanData: String = ""
    var gameTitle = ""
    var gameDBID = ""
    var isWaiting = false
    
    var gameDetails: BoardGames.BoardGame = BoardGames.BoardGame(objectid: "",
                                                                 primary: "",
                                                                 name: "",
                                                                 yearpublished: "",
                                                                 minplayers: 2,
                                                                 maxplayers: 20,
                                                                 playingtime: 0)
    
    init(rawScanData: String = "") {
        if rawScanData != "" {
            self.rawScanData = rawScanData
        }
    }
    
    func search(completion: @escaping (Result<BoardGames.BoardGame, APIFailure>) -> Void) {
        self.getGameFromCode() { result1 in
            switch result1 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let gameTitle):
                print("Barcode API Search Complete")
                print(gameTitle)
                self.gameTitle = gameTitle
                    
                self.getGameIDFromDB(gameTitle: gameTitle) { result2 in
                    switch result2 {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let gameID):
                        print("Database Lookup Complete")
                        print(gameID)
                        self.gameDBID = gameID
                                
                        self.getGameDataFromDB(gameID: gameID) { result3 in
                            switch result3 {
                            case .failure(let error):
                                completion(.failure(error))
                            case .success(let gameData):
                                print("Database Data Lookup Complete")
                                print(gameData)
                                self.gameDetails = gameData.boardgame[0]
                                
                                completion(.success(gameData.boardgame[0]))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func stripPhrases(string: String, additional: [String] = []) -> String {
        var strippedString = string.capitalized
        let commonPhrases: [String] = ["Strategy", "Board Game", " - "]
        let allPhrases: [String] = additional + commonPhrases
        for phrase in allPhrases { strippedString = strippedString.replacingOccurrences(of: phrase.capitalized, with: "") }
        strippedString = strippedString.trimmingCharacters(in: .whitespacesAndNewlines)
        return strippedString
    }
    
    func getGameFromCode(completion: @escaping (Result<String, APIFailure>) -> Void) {
        let url = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(rawScanData)"
        self.fetchData(from: url) { result in
            switch result {
                case .success(let str):
                    self.rawAPIResult.append([url, str])
                    let data = str.data(using: .utf8)!
                    
                    let upcData: UPCData = try! JSONDecoder().decode(UPCData.self, from: data)
                    if upcData.items.isEmpty {
                        completion(.failure(.noUPCResults))
                        return
                    }
                    completion(.success(self.stripPhrases(string: upcData.items[0].title, additional: [upcData.items[0].brand])))
                case .failure(_):
                    completion(.failure(.NetworkError))
            }
        }
    }
    
    func getGameIDFromDB(gameTitle: String, completion: @escaping (Result<String, APIFailure>) -> Void) {
        let urlGameTitle = gameTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = "https://www.boardgamegeek.com/xmlapi/search?exact=1&search=\(urlGameTitle)"
        self.fetchData(from: url) { result in
            switch result {
                case .success(let str):
                    self.rawAPIResult.append([url, str])
                    let data = str.data(using: .utf8)!
                    print([url, str])
                    let gameDBSearch = try! XMLDecoder().decode(BoardGamesSearch.self, from: data)
                    
                    if gameDBSearch.boardgame.isEmpty {
                        completion(.failure(.noDBResults))
                        return
                    }
                    completion(.success(gameDBSearch.boardgame[0].objectid))
                case .failure(_):
                    completion(.failure(.NetworkError))
            }
        }
    }
    
    func getGameDataFromDB(gameID: String, completion: @escaping (Result<BoardGames, APIFailure>) -> Void) {
        let url = "https://www.boardgamegeek.com/xmlapi/boardgame/\(gameID)"
        print(url)
        self.fetchData(from: url) { result in
            switch result {
                case .success(let str):
                    self.rawAPIResult.append([url, str])
                    let data = str.data(using: .utf8)!
                    
                    let gameData = try! XMLDecoder().decode(BoardGames.self, from: data)
                    
                    if gameData.boardgame.isEmpty {
                        completion(.failure(.noGameDataResults))
                    }
                    completion(.success(gameData))
                case .failure(_):
                    completion(.failure(.NetworkError))
            }
        }
    }
    
    class ScanResult: ObservableObject {
        @Published var people: [ScanResult]

        init() {
            self.people = []
        }
    }
    
    func errorMessage(error: APIFailure) -> String {
        var message = ""
        switch error {
        case .NetworkError:
            message = "An API call returned a connection error."
        case .noUPCResults:
            message = "The UPC scanned did not return any product information."
        case .noDBResults:
            message = "The BoardGameGeek database could not find a game titled \".gameTitle\"."
        case .noGameDataResults:
            message = "The BoardGameGeek database struggled to find the full game data."
        case .unknown:
            message = "Something went wrong."
        }
        return message
    }
    
    enum APIFailure: Error {
        case noUPCResults, noDBResults, noGameDataResults, NetworkError, unknown
    }
    
    enum NetworkError: Error {
        case badURL, requestFailed, unknown
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        // check the URL is OK, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    // success: convert the data to a string and send it back
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
    
    struct UPCData: Decodable {
        struct Items: Decodable {
            let title: String
            let brand: String
        }
        let items: [Items]
    }
    
    struct BoardGamesSearch: Codable {
        struct BoardGame: Codable, Equatable, DynamicNodeDecoding {
            let objectid: String
            let name: String
            let yearpublished: String
            
            enum CodingKeys: String, CodingKey {
                case objectid
                case name
                case yearpublished
            }
            
            static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
                switch key {
                case CodingKeys.objectid:
                    return .attribute
                default:
                    return .element
                }
            }
        }
        let boardgame: [BoardGame]
    }

    struct BoardGames: Codable {
        struct BoardGame: Codable, Equatable, DynamicNodeDecoding {
            let objectid: String
            let primary: String
            let name: String
            let yearpublished: String
            let minplayers: Int
            let maxplayers: Int
            let playingtime: Int
            
            enum CodingKeys: String, CodingKey {
                case objectid
                case primary
                case name
                case yearpublished
                case minplayers
                case maxplayers
                case playingtime
            }
            
            static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
                switch key {
                case CodingKeys.objectid:
                    return .attribute
                case CodingKeys.primary:
                    return .element
                default:
                    return .element
                }
            }
        }
        let boardgame: [BoardGame]
    }
}
