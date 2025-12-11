//
//  userStores.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import Combine
import SwiftUI

class UserStores:ObservableObject {
    @AppStorage("wantsHaptics") var wantsHaptics:Bool = true
    @AppStorage("wantsSounds") var wantsSounds:Bool = true
    @AppStorage("currentModelName") var currentModelName: String?
    private let installedModelsKey = "installedModels"
    
    
    @Published var installedModels: [String] = [] {
        didSet {
            saveInstalledModelsToUserDefaults()
        }
    }
    
    init() {
        loadInstalledModelsFromUserDefaults()
    }
    
    private func saveInstalledModelsToUserDefaults() {
        if let jsonData = try? JSONEncoder().encode(installedModels) {
            UserDefaults.standard.set(jsonData, forKey: installedModelsKey)
        }
    }
    
    
    private func loadInstalledModelsFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: installedModelsKey),
           let decodedArray = try? JSONDecoder().decode([String].self, from: jsonData) {
            self.installedModels = decodedArray
        } else {
            self.installedModels = []
        }
    }
    
    
    func addInstalledModel(_ model: String) {
        if !installedModels.contains(model) {
            installedModels.append(model)
        }
    }
    
    func modelDisplayName(_ modelName: String) -> String {
        return modelName.replacingOccurrences(of: "mlx-community/", with: "").lowercased()
    }
}
