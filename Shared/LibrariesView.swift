//
//  LibrariesView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

struct LibrariesView: View {
    @EnvironmentObject var libraryData: LibraryData
    @EnvironmentObject var menuBar: MenuBar
    @State private var editMode = EditMode.inactive
    @Environment(\.scenePhase) private var scenePhase
    @State private var isLibraryEditorPresented = false
    @State private var isNewLibraryEditorPresented = false
    @State private var isNewLibrary = false
    @State private var newLibraryShell = Library()
    @State private var currentLib = Library()
    let saveAction: () -> Void
    
    var body: some View {
        List {
            ForEach(libraryData.libraries) {library in
                LibraryCardView(library: library)
                    .onTapGesture {
                        switch editMode {
                            case .inactive:
                                libraryData.activateLibrary(library: library)
                                menuBar.selectTab(1)
                            default:
                                currentLib = library
                                isNewLibrary = false
                                isLibraryEditorPresented = true
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .onDelete(perform: deleteLibrary)
            .onMove(perform: onMove)
        }
        .navigationTitle("Game Libraries")
        .navigationBarItems(leading: EditButton(), trailing: addButton)
        .environment(\.editMode, $editMode)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .sheet(isPresented: $isLibraryEditorPresented) {
            NavigationView {
                LibraryEditView(libraryData: $currentLib, isNewLibrary: $isNewLibrary)
                    .navigationBarItems(trailing: Button("Save") {
                        libraryData.updateLibraryDetails(library: currentLib)
                        isLibraryEditorPresented = false
                    })
            }
        }
        .sheet(isPresented: $isNewLibraryEditorPresented) {
            NavigationView {
                LibraryEditView(libraryData: $newLibraryShell, isNewLibrary: $isNewLibrary)
                    .navigationBarItems(leading: Button("Dismiss") {
                        isNewLibraryEditorPresented = false
                        newLibraryShell = Library()
                    }, trailing: Button("Add") {
                        let newLibrary = newLibraryShell
                        libraryData.libraries.append(newLibrary)
                        isNewLibraryEditorPresented = false
                        newLibraryShell = Library()
                    })
            }
        }
    }
    
    private var addButton: some View {
        switch editMode {
            case .inactive:
                return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
            default:
                return AnyView(EmptyView())
        }
    }
    
    func onAdd() {
        isNewLibrary = true
        isNewLibraryEditorPresented = true
    }
    
    private func deleteLibrary(at offsets: IndexSet) {
        libraryData.libraries.remove(atOffsets: offsets)
    }
    private func onMove(source: IndexSet, destination: Int) {
        libraryData.libraries.move(fromOffsets: source, toOffset: destination)
    }
}

struct LibrariesView_Previews: PreviewProvider {
    static var previews: some View {
        let libraryData: LibraryData = LibraryData()
        NavigationView {
            LibrariesView(saveAction: {})
                .environmentObject(libraryData)
                .environmentObject(MenuBar())
                .onAppear() {
                    libraryData.load()
                }
        }
    }
}
