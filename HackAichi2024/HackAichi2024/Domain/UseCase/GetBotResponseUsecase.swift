//
//  GetBotResponseUsecase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation

protocol GetBotResponseUseCase {
    func respondToMessage(_ message: Message) async throws -> Message
}

class GetBotResponseUseCaseImpl: GetBotResponseUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntryRepository: QAEntryRepository = LocalQAEntryRepository.shared) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
    }
    
    func respondToMessage(_ message: Message) async throws -> Message {
        let embedding = try await embeddingService.embed(text: message.content)
        let qaEntries = try await qaEntryRepository.vectorSimilar(to: embedding, k: 1)
//            とりあえず質問に近い回答を返すようにする
        return Message(id: .init(), sender: .bot, content: qaEntries[0].answer, timestamp: Date())
    }
}
