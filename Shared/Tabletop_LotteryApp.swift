//
//  Tabletop_LotteryApp.swift
//  Shared
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

@main
struct Tabletop_LotteryApp: App {
    @ObservedObject private var data = GameData()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                //MenuBarView(games: $data.games) {
                GamesView(games: $data.games) {
                    data.save()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear() {
                data.load()
            }
        }
    }
}
