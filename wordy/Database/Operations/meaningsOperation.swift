//
//  meaningsOperation.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 09/12/2025.
//

import Foundation
import GRDB

class MeaningsOperation {
    private let appDatabase: AppDatabase   
    init(_ appDatabase: AppDatabase) {
        self.appDatabase = appDatabase
    }
    
    func save(_ meaning: inout LocalMeaningModel) async throws -> Bool {
        try await appDatabase.dbWriter.write { db in
            try meaning.save(db)
           
        }
        return meaning.id != nil
        
    }

    func delete(_ meaning: inout LocalMeaningModel) async throws {
        try await appDatabase.dbWriter.write { db in
            try meaning.delete(db)
        }
    }
}
