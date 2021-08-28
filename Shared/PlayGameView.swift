//
//  PlayGameView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/24/21.
//

import SwiftUI

struct PlayGameView: View {
    @Binding var game: TabletopGame
    @State var currentPlayRating: Double = 0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(game.color)
            VStack {
                Section(header: Text("Rating")) {
                    HStack {
                        Slider(value: $currentPlayRating, in: 0...5, step: 0.5) {
                            Text("Game Rating")
                        }
                        .accessibilityValue(Text("Rated \(Int(currentPlayRating)) stars"))
                        Text("\(currentPlayRating, specifier: "%.1f")")
                            .accessibilityHidden(true)
                        Image(systemName: "star.fill")
                    }
                    .background(Color.white)
                    .foregroundColor(game.color)
                }
                .padding(.top)
                Circle()
                    .strokeBorder(lineWidth: 24, antialiased: true)
                //MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(game.color.accessibleFontColor)
        .onAppear {
            
        }
        .onDisappear {
            let newHistory = History(lengthInMinutes: 0, rating: Rating(currentPlayRating))
            game.history.insert(newHistory, at: 0)
            game.recalculateRating()
        }
        .navigationTitle(game.title)
    }
}

struct PlayGameView_Previews: PreviewProvider {
    static var previews: some View {
        PlayGameView(game: .constant(TabletopGame.data[0]))
    }
}
