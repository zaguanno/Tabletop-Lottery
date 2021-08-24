//
//  EditView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

struct EditView: View {
    @Binding var gameData: TabletopGame.Data
    var body: some View {
        List {
            Section(header: Text("Game Info")) {
                TextField("Title", text: $gameData.title)
                HStack {
                    VStack {
                        Text("Base Game")
                            .font(.caption)
                        HStack {
                            Image(systemName: "rectangle")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Toggle("", isOn: $gameData.typeIsBase)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Expansion")
                            .font(.caption)
                        HStack {
                            Image(systemName: "plus.rectangle.on.rectangle")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Toggle("", isOn: $gameData.typeIsExpansion)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Variant")
                            .font(.caption)
                        HStack {
                            Image(systemName: "rectangle.on.rectangle.angled.fill")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Toggle("", isOn: $gameData.typeIsVariant)
                        }
                    }
                }
                HStack {
                    Slider(value: $gameData.lengthInMinutes, in: 5...120, step: 1.0) {
                        Text("Length")
                    }
                    .accessibilityValue(Text("\(Int(gameData.lengthInMinutes)) minutes"))
                    Spacer()
                    Text("\(Int(gameData.lengthInMinutes)) minutes")
                        .accessibilityHidden(true)
                }
                ColorPicker("Color", selection: $gameData.color)
                    .accessibilityLabel(Text("Color picker"))
            }
            Section(header: Text("Number of Players")) {
                HStack {
                    Text("Min \(Int(gameData.minimumPlayers))")
                        .accessibilityHidden(true)
                        .font(.caption)
                    Slider(value: $gameData.minimumPlayers, in: 2...gameData.maximumPlayers, step: 1.0) {
                        Text("Minimum Number of Players")
                    }
                    .accessibilityValue(Text("\(Int(gameData.minimumPlayers)) players minimum"))
                    Spacer()
                    Slider(value: $gameData.maximumPlayers, in: gameData.minimumPlayers...20, step: 1.0) {
                        Text("Minimum Number of Players")
                    }
                    .accessibilityValue(Text("\(Int(gameData.maximumPlayers)) players maximum"))
                    Text("\(Int(gameData.maximumPlayers)) Max")
                        .accessibilityHidden(true)
                        .font(.caption)
                }
            }
            Section(header: Text("Rating")) {
                HStack {
                    Slider(value: $gameData.rating, in: 0...5, step: 0.5) {
                        Text("Game Rating")
                    }
                    .accessibilityValue(Text("Rated \(Int(gameData.rating)) stars"))
                    Text("\(gameData.rating, specifier: "%.1f")")
                        .accessibilityHidden(true)
                    Image(systemName: "star.fill")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(gameData: .constant(TabletopGame.data[1].data))
    }
}
