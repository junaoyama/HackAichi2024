//
//  LocalRepositoryProviderService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation
import SQLiteVec

class LocalRepositoryProviderService: RepositoryProviderService {
    static let shared: LocalRepositoryProviderService = .init()
    private lazy var database: Database = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = path.appendingPathComponent("myDatabase.sqlite").path
        return try! Database(.uri(dbPath))
    }()
    
    private lazy var localQAEntryRepository: LocalQAEntryRepository = LocalQAEntryRepository(database: database)
    private lazy var localMessageLogRepository: LocalMessageLogRepository = LocalMessageLogRepository(database: database)
    
    private init() {
//        これが実行できないとベクトル検索ができないので落ちるのが良い
        try! SQLiteVec.initialize()
    }
    
    func get() -> any QAEntryRepository {
        return localQAEntryRepository
    }
    
    func get() -> any MessageLogRepository {
        return localMessageLogRepository
    }
}
