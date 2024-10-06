//
//  GetBotResponseUsecase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import OpenAI

class GetBotResponseUseCaseImpl: AskChatBotUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    private let messageLogRepository: MessageLogRepository
    private let llmService: LLMService
    private let failureThreshold: Float = 0.3
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntryRepository: QAEntryRepository = LocalRepositoryProviderService.shared.get(), messageLogRepository: MessageLogRepository = LocalRepositoryProviderService.shared.get(), llmService: LLMService = OpenAIService.shared) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
        self.messageLogRepository = messageLogRepository
        self.llmService = llmService
    }
    
    func askQuestion(_ message: Message) async throws -> ChatBotResponse {
//        質問を記録する
        try await messageLogRepository.save(message: message)
        let embedding = try await embeddingService.embed(text: message.content)
        var result = try await qaEntryRepository.vectorSimilar(to: embedding, k: 15)
        if result[0].distance > failureThreshold {
            return ChatBotResponse.fail
        }
        
        result = result.filter({ $0.distance < failureThreshold })
        let qaEntries = result.map({ $0.qaEntry })
        
        let ref = qaEntries.map({ "question: " + $0.question + ", " + "answer: " + $0.answer }).joined(separator: "\n")
        let answer = try await llmService.askLLM(question: message.content, context: ref)
        let answerMessage = Message(id: .init(), sender: .bot, content: answer, sentAt: Date())
//        答えを記録する
        try await messageLogRepository.save(message: answerMessage)
        return ChatBotResponse.success(answerMessage)
    }
}
