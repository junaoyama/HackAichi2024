//
//  GetBotResponseUsecase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation

class GetBotResponseUseCaseImpl: AskChatBotUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    private let messageLogRepository: MessageLogRepository
    private let failureThreshold: Float = 0.3
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntryRepository: QAEntryRepository = LocalRepositoryProviderService.shared.get(), messageLogRepository: MessageLogRepository = LocalRepositoryProviderService.shared.get()) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
        self.messageLogRepository = messageLogRepository
    }
    
    func askQuestion(_ message: Message) async throws -> ChatBotResponse {
//        質問を記録する
        try await messageLogRepository.save(message: message)
        let embedding = try await embeddingService.embed(text: message.content)
        let result = try await qaEntryRepository.vectorSimilar(to: embedding, k: 2)
        if result[0].distance > failureThreshold {
            return ChatBotResponse.fail
        }
//            とりあえず質問に近い回答を返すようにする
        let answer = Message(id: .init(), sender: .bot, content: result[0].qaEntry.answer, sentAt: Date())
//        答えを記録する
        try await messageLogRepository.save(message: answer)
        return ChatBotResponse.success(answer)
    }
}
