//
//  MenuBarView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/30/21.
//

import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var libraryData: LibraryData
    @EnvironmentObject var menuBar: MenuBar
    @Binding var libraries: [Library]
    @Binding var games: [TabletopGame]
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
                //let activeLibraryBinding = binding(for: libraryData.activeLibrary)
                //GamesView(games: activeLibraryBinding!.games, saveAction: saveAction)
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
            .tabItem {
                Label("Spin the Wheel", systemImage: "arrow.2.circlepath")
            }
            .tag(2)
            
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
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }
    }
    
    private func binding(for library: Library) -> Binding<Library>? {
        guard let libraryIndex = libraryData.libraries.firstIndex(where: { $0.id == library.id }) else {
            return nil
            //fatalError("Can't find library in array")
        }
        return $libraryData.libraries[libraryIndex]
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        let libraryData = LibraryData()
        MenuBarView(libraries: .constant(Library.data), games: .constant(TabletopGame.data), saveAction: {})
            .environmentObject(libraryData)
            .environmentObject(MenuBar(0))
            .onAppear() {
                libraryData.load()
            }
    }
}
