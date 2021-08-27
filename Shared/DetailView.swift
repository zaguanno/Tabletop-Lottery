//
//  DetailView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

struct DetailView: View {
    @Binding var game: TabletopGame
    @Binding var games: [TabletopGame]
    @State private var data: TabletopGame.Data = TabletopGame.Data()
    @State private var isPresented = false
    @State private var isNewGame = false
    
    var body: some View {
        List {
            HStack {
                Spacer()
                (game.rating >= 1) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (game.rating >= 2) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (game.rating >= 3) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (game.rating >= 4) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (game.rating >= 5) ? Image(systemName: "star.fill") : Image(systemName: "star")
                Spacer()
            }
            Section(header: Text("Game Info")) {
                HStack {
                    VStack {
                        Image(systemName: "rectangle")
                        Text("Base Game")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(game.typeIsBase ? Color.green : Color.gray)
                    Spacer()
                    VStack {
                        Image(systemName: "plus.rectangle.on.rectangle")
                        Text("Expansion")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(game.typeIsExpansion ? Color.green : Color.gray)
                    Spacer()
                    VStack {
                        Image(systemName: "rectangle.on.rectangle.angled.fill")
                        Text("Variant")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(game.typeIsVariant ? Color.green : Color.gray)
                }
                HStack {
                    Label("Number of Players", systemImage: "person.3")
                        .accessibilityLabel(Text("Game length"))
                    Spacer()
                    Text("\(game.minimumPlayers) - \(game.maximumPlayers)")
                }
                HStack {
                    Label("Length", systemImage: "clock")
                        .accessibilityLabel(Text("Game length"))
                    Spacer()
                    Text("\(game.lengthInMinutes) minutes")
                }
                HStack {
                    Label("Color", systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(game.color)
                }
                .accessibilityElement(children: .ignore)
            }
            Section(header: Text("History")) {
                if game.history.isEmpty {
                    Label("This game hasn't been played yet.", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(game.history) {history in
                    HStack {
                        Image(systemName: "calendar")
                        Text(history.date, style: .date)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            data = game.data
        })
        .navigationTitle(game.title)
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                EditView(gameData: $data, games: $games, isNewGame: $isNewGame)
                    .navigationTitle(game.title)
                    .navigationBarItems(leading: Button("Cancel") {
                        isPresented = false
                    }, trailing: Button("Done") {
                        isPresented = false
                        game.update(from: data)
                    })
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(game: .constant(TabletopGame.data[0]), games: .constant(TabletopGame.data))
        }
    }
}
