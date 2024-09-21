//
//  MessageLogRepository.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

//Messageのログを取ったり取得したりする
protocol MessageLogRepository {
    ///return: 直近n件のMessage
    func fetchRecentMessages(n: Int) async throws -> [Message]
    func save(message: Message) async throws
}
