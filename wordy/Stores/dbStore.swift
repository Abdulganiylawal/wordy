

import Foundation
import GRDB

@Observable
class DbStore {
    private let appDatabase: AppDatabase
        @ObservationIgnored private var cancellable: AnyDatabaseCancellable?
    @ObservationIgnored private var meaningsOperation: MeaningsOperation
    init(_ appDatabase: AppDatabase) {
        self.appDatabase = appDatabase
        self.meaningsOperation = MeaningsOperation(appDatabase)
    }
    var meanings: [MeaningModel] = []
    var localMeanings: [LocalMeaningModel] = []

    func observeDb() {
        let observation = ValueObservation.tracking { db -> [LocalMeaningModel] in
            return try LocalMeaningModel.fetchAll(db)
        }
         cancellable = observation.start(in: appDatabase.reader)  { error in
            debugLog("Error observing database: \(error)")
        } onChange: { [weak self] meanings in
            self?.localMeanings = meanings
            do {
                self?.meanings = try meanings.map { try LocalMeaningModel.toMeaningModel(localMeaning: $0) }
                debugLog("Meanings: \(self?.meanings)")
            } catch {
                debugLog("Error converting local meanings to meanings: \(error.localizedDescription)") 
            }
          
        }
       
    }
}


extension DbStore {
    func saveMeaning(_ meaning: LocalMeaningModel) async {
        var meaning = meaning
        do {
            let saved = try await meaningsOperation.save(&meaning)
            debugLog("Meaning saved: \(saved)")
        } catch {
            debugLog("Error saving meaning: \(error)")
        }
        
    }
}
