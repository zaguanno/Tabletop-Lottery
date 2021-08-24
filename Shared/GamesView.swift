//
//  GamesView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

struct GamesView: View {
    @Binding var games: [TabletopGame]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresented = false
    @State private var isWheelPresented = false
    @State private var newGameData = TabletopGame.Data()
    let saveAction: () -> Void
    
    var body: some View {
        List {
            ForEach(games) {game in
                NavigationLink(destination: DetailView(game: binding(for: game))) {
                    CardView(game: game)
                }
                .listRowBackground(game.color)
            }
        }
        .navigationTitle("My Tabletop Games")
        .navigationBarItems(leading: Button(action: {
            isWheelPresented = true
        }) {
            Label("Spin the Wheel", systemImage: "arrow.2.circlepath")
        }, trailing: Button(action: {
            isPresented = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isWheelPresented) {
            NavigationView {
                LotteryWheelView(games: $games)
                    .navigationBarItems(leading: Button("Dismiss") {
                        isWheelPresented = false
                    })
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                EditView(gameData: $newGameData)
                    .navigationBarItems(leading: Button("Dismiss") {
                        isPresented = false
                    }, trailing: Button("Add") {
                        let newGame = TabletopGame(title: newGameData.title, typeIsBase: newGameData.typeIsBase, typeIsExpansion: newGameData.typeIsExpansion, typeIsVariant: newGameData.typeIsVariant, minimumPlayers: Int(newGameData.minimumPlayers), maximumPlayers: Int(newGameData.maximumPlayers),  lengthInMinutes: Int(newGameData.lengthInMinutes), color: newGameData.color, rating: newGameData.rating)
                        games.append(newGame)
                        isPresented = false
                        newGameData = TabletopGame.Data()
                    })
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    private func binding(for game: TabletopGame) -> Binding<TabletopGame> {
        guard let gameIndex = games.firstIndex(where: { $0.id == game.id }) else {
            fatalError("Can't find game in array")
        }
        return $games[gameIndex]
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GamesView(games: .constant(TabletopGame.data), saveAction: {})
        }
    }
}
