import Foundation
import GRDB
import os.log



struct AppDatabase:Sendable {
    let dbWriter: any DatabaseWriter
    
    init(_ dbWriter: any GRDB.DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
        
    }
    
    
    
    private lazy var migrator: DatabaseMigrator = {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createMeaningsTable") { db in
            try db.create(table: "meanings") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("partOfSpeech", .text).notNull()
                t.column("phonetics", .text).notNull()
                t.column("definitions", .text).notNull()
            }
        }
        return migrator
    }()
}

extension AppDatabase {
    
    static func makeConfiguration(_ config: Configuration = Configuration()) -> Configuration {
        return config
    }
}


extension AppDatabase {
    /// Provides a read-only access to the database.
    var reader: any GRDB.DatabaseReader {
        dbWriter
    }
}

extension AppDatabase {
    static let shared = makeShared()
    
    private static func makeShared() -> AppDatabase {
        do {
            let fileManager = FileManager.default
            let appSupportURL = try fileManager.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: true)
            let directoryURL = appSupportURL.appendingPathComponent("Database", isDirectory: true)
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            
            let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
            let config = AppDatabase.makeConfiguration()
            let dbPool = try DatabasePool(path: databaseURL.path, configuration: config)
            
            let appDatabase = try AppDatabase(dbPool)
            return appDatabase
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    // Use in Swift UI preview
    static func empty() -> AppDatabase {
        let dbQueue = try! DatabaseQueue(configuration: AppDatabase.makeConfiguration())
        return try! AppDatabase(dbQueue)
    }
}


