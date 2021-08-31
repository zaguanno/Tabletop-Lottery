//
//  MenuBarView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/30/21.
//

import SwiftUI

struct MenuBarView: View {
    @State var selection: Int = 2
    @Binding var games: [TabletopGame]
    let saveAction: () -> Void
    
    var body: some View {
        TabView(selection: $selection) {
            GamesView(games: $games, saveAction: saveAction)
                .tabItem {
                    Label("Libraries", systemImage: "questionmark")
                }
                .tag(0)

            GamesView(games: $games, saveAction: saveAction)
                .tabItem {
                    Label("Games", systemImage: "cube.box.fill")
                }
                .tag(1)
            
            LotteryWheelView(games: $games)
                .tabItem {
                    Label("Spin the Wheel", systemImage: "arrow.2.circlepath")
                }
                .tag(2)
            
            GamesView(games: $games, saveAction: saveAction)
                .tabItem {
                    Label("Search", systemImage: "questionmark")
                }
                .tag(3)
            
            GamesView(games: $games, saveAction: saveAction)
                .tabItem {
                    Label("Players", systemImage: "questionmark")
                }
                .tag(4)
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView(games: .constant(TabletopGame.data), saveAction: {})
    }
}
