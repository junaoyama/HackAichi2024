//
//  LoadChatHistoryUseCase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

protocol LoadMessageHistoryUseCase {
    func load() async throws -> [Message]
}
