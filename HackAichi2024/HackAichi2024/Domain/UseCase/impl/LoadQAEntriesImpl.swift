//
//  LoadQAEntries.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

class LocalLoadQAEntriesUseCaseImpl: LoadQAEntriesUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    private let loadFileService: LoadFileService
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntryRepository: QAEntryRepository = LocalRepositoryProviderService.shared.get(), loadFileService: LoadFileService = YamlLoadFileService()) {
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
            let demoPath = URL(filePath: Bundle.main.path(forResource: "demo", ofType: "yaml")!)
            let qaEntries = try loadFileService.load(path: demoPath)
            for qaEntry in qaEntries {
                let embedding = try await self.embeddingService.embed(text: qaEntry.question)
                try await self.qaEntryRepository.save(qaEntry: qaEntry, embedding: embedding)
            }
            UserDefaults.standard.setValue(true, forKey: "alreadyLaunched")
        }
    }
}
