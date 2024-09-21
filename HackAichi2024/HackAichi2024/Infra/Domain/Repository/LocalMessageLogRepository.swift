//
//  LocalMessageLogRepository.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation
import SQLiteVec

actor LocalMessageLogRepository: MessageLogRepository {
    private var database: Database
    
    init(database: Database) {
        self.database = database
    }

    func fetchRecentMessages(n: Int) async throws -> [Message] {
        try await createTableIfNeed()
        let messages = try await database.query(
            """
                SELECT *
                from Messages
                ORDER BY id DESC;
            """
        )
        
        return messages.compactMap({
            guard let id = $0["message_id"] as? String, let id = UUID(uuidString: id) else {
                return nil
            }
            guard let senderId = $0["sender_type"] as? Int, let sender = Message.Sender(rawValue: senderId) else {
                return nil
            }
            guard let content = $0["content"] as? String else {
                return nil
            }
            guard let sentAt = $0["sent_at"] as? String, let sentAt = SQLite3DataFormatter.convert(from: sentAt) else {
                return nil
            }
            return .init(id: id, sender: sender, content: content, sentAt: sentAt)
        })
    }
    
    func save(message: Message) async throws {
        try await createTableIfNeed()
        try await database.execute(
            """
                INSERT INTO Messages(message_id, content, sender_type, sent_at) VALUES(?, ?, ?, ?);
            """,
            params: [
                        message.id.uuidString,
                        message.content,
                        message.sender.rawValue,
                        SQLite3DataFormatter.convert(from: message.sentAt)
                    ]
        )
    }
    
    private func createTableIfNeed() async throws {
//        一個一個のメッセージ用のテーブル
        try await database.execute(
            """
                CREATE TABLE IF NOT EXISTS Messages(
                    id INTEGER PRIMARY KEY,
                    message_id TEXT,
                    content TEXT,
                    sender_type INTEGER,
                    sent_at TEXT
                );
            """
        )
    }
}
