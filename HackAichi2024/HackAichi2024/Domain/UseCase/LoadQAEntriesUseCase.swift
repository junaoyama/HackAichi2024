//
//  ConnectDBUseCase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import Yams
import Accelerate

protocol LoadQAEntriesUseCase {
    func loadIfNeed() async throws
}

class LocalLoadQAEntriesUseCase: LoadQAEntriesUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    private let loadFileService: LoadFileService
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntryRepository: QAEntryRepository = LocalQAEntryRepository.shared, loadFileService: LoadFileService = YamlLoadFileService()) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
        self.loadFileService = loadFileService
    }
//    初回起動時のみデータを読み込むこととする
//    yamlを読みこみ -> Embedding -> dbに登録
    func loadIfNeed() async throws {
//        UserDefaultsのboolの初期値がfalseであるため
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "alreadyLaunched")
        if isFirstLaunch {
            let qaEntries = try loadFileService.load()
            for qaEntry in qaEntries {
                let embedding = try await self.embeddingService.embed(text: qaEntry.question)
                try await self.qaEntryRepository.save(qaEntry: qaEntry, embedding: embedding)
            }
            UserDefaults.standard.setValue(true, forKey: "alreadyLaunched")
        }
    }
}
