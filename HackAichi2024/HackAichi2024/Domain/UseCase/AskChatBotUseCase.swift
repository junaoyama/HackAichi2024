//
//  GetBotResponse.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

protocol AskChatBotUseCase {
    func askQuestion(_ message: Message) async throws -> ChatBotResponse
}

enum ChatBotResponse {
    case success(Message)
    case fail
}
