//
//  GetBotResponse.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

protocol GetBotResponseUseCase {
    func respondToMessage(_ message: Message) async throws -> Message
}
