//
//  RecommendUseCaseImpl.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/23.
//

import Foundation

class RecommendUseCaseImpl: RecommendUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntriesRepository: QAEntryRepository
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntriesRepository: QAEntryRepository = LocalRepositoryProviderService.shared.get()) {
        self.embeddingService = embeddingService
        self.qaEntriesRepository = qaEntriesRepository
    }

    func recommend(from message: String) async throws -> String {
        if Task.isCancelled { throw AppError.tooManyVectorSearchRequest }
        let embedding = try await embeddingService.embed(text: message)
        let qaEntry = try await qaEntriesRepository.vectorSimilar(to: embedding, k: 1)
        return qaEntry.first!.question
    }
}
