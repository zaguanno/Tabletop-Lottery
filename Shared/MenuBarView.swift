//
//  MenuBarView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/30/21.
//

import SwiftUI

struct MenuBarView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var libraryData: LibraryData
    @EnvironmentObject var menuBar: MenuBar
    @Binding var libraries: [Library]
    let saveAction: () -> Void
    
    var body: some View {
        TabView(selection: $menuBar.tabSelection) {
            NavigationView {
                LibrariesView(saveAction: saveAction)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Libraries", systemImage: "bookmark.fill")
            }
            .tag(0)
            
            NavigationView {
                GamesView(games: $libraryData.activeLibrary.games, saveAction: saveAction)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Games", systemImage: "cube.box.fill")
            }
            .tag(1)
            
            NavigationView {
                LotteryWheelView(games: $libraryData.activeLibrary.games)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Random Picker", systemImage: "arrow.2.circlepath")
            }
            .tag(2)
            /*
            NavigationView {
                EmptyView()
            }
            .tabItem {
                Label("Search", systemImage: "questionmark")
            }
            .tag(3)
            
            NavigationView {
                EmptyView()
            }
            .tabItem {
                Label("Players", systemImage: "questionmark")
            }
            .tag(4)
            */
        }
        .onChange(of: menuBar.tabSelection) { newValue in
            saveAction()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        let libraryData = LibraryData()
        MenuBarView(libraries: .constant(Library.data), saveAction: {})
            .environmentObject(libraryData)
            .environmentObject(MenuBar(2))
            .onAppear() {
                libraryData.load()
            }
    }
}
