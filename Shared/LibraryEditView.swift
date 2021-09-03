//
//  LibraryEditView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 9/2/21.
//

import SwiftUI

struct LibraryEditView: View {
    @Binding var libraryData: Library
    @Binding var isNewLibrary: Bool
    var body: some View {
        List {
            Section(header: Text("Library Title")) {
                TextField("Title", text: $libraryData.title)
            }
            Section(header: Text("Library Color")) {
                ColorPicker("Color", selection: $libraryData.color)
                    .accessibilityLabel(Text("Color picker"))
            }
        }
    }
}

struct LibraryEditView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryEditView(libraryData: .constant(Library()), isNewLibrary: .constant(false))
    }
}
