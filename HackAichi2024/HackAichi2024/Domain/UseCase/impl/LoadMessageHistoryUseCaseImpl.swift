//
//  LoadChatHistoryUseCase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

class LoadMessageHistoryUseCaseImpl: LoadMessageHistoryUseCase {
    private let messageLogRepository: MessageLogRepository
    
    init(messageLogRepository: MessageLogRepository = LocalRepositoryProviderService.shared.get()) {
        self.messageLogRepository = messageLogRepository
    }
    
    func load() async throws -> [Message] {
        return try await messageLogRepository.fetchRecentMessages(n: 4)
    }
}
