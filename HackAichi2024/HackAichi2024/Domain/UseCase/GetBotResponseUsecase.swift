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
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService(), qaEntryRepository: QAEntryRepository = LocalQAEntryRepository()) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
    }
    
    func respondToMessage(_ message: Message) async throws -> Message {
        if message.sender == .user {
            let embedding = try await embeddingService.embed(text: message.content)
            let qaEntries = try await qaEntryRepository.vectorSimilar(to: embedding, k: 1)
//            近い回答を見て何かする
            return Message(id: .init(), sender: .bot, content: qaEntries[0].answer, timestamp: Date())
        } else {
            fatalError()
        }
    }
}
