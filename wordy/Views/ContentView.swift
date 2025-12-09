//
//  ContentView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import SwiftUI
import GRDB

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var dbStore: DbStore
    


    init(_ appDatabase: AppDatabase) {
      
        _dbStore = State(initialValue: DbStore(appDatabase))
        dbStore.observeDb()
    }

    var body: some View {
        WordView()
            .environment(dbStore)
    }
}

#Preview {
    ContentView(.empty())
}
