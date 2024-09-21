//
//  GetBotResponseUsecase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation

class GetBotResponseUseCaseImpl: GetBotResponseUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    private let messageLogRepository: MessageLogRepository
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntryRepository: QAEntryRepository = LocalRepositoryProviderService.shared.get(), messageLogRepository: MessageLogRepository = LocalRepositoryProviderService.shared.get()) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
        self.messageLogRepository = messageLogRepository
    }
    
    func respondToMessage(_ message: Message) async throws -> Message {
//        質問を記録する
        try await messageLogRepository.save(message: message)
        let embedding = try await embeddingService.embed(text: message.content)
        let qaEntries = try await qaEntryRepository.vectorSimilar(to: embedding, k: 1)
//            とりあえず質問に近い回答を返すようにする
        let answer = Message(id: .init(), sender: .bot, content: qaEntries[0].answer, sentAt: Date())
//        答えを記録する
        try await messageLogRepository.save(message: answer)
        return answer
    }
}
