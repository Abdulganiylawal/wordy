//
//  DownloadLLMView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 11/12/2025.
//

import SwiftUI

struct DownloadLLMView: View {
    @Environment(LocalLLmService.self) var localLLM
    @EnvironmentObject var prefrences: UserStores
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DownloadLLMView()
}
