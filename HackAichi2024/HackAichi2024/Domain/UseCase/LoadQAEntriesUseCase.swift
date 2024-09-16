//
//  ConnectDBUseCase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation

protocol LoadQAEntriesUseCase {
    func load() async throws
}

class LocalLoadQAEntriesUseCase: LoadQAEntriesUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    
    init(embeddingService: EmbeddingService, qaEntryRepository: QAEntryRepository) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
    }
//    すでにデータが登録されていれば何も行わない
//    csvを読みこみ -> Embedding -> dbに登録
    func load() async throws {
        
    }
}
