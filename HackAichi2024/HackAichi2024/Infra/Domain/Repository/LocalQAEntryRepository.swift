//
//  LocalDatabase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import SQLiteVec

actor LocalQAEntryRepository: QAEntryRepository {
    private let database = try! Database(.inMemory)

    func setUpDB() async throws {
        
//        QAテーブルを作成
        try await database.execute(
            """
                CREATE TABLE IF NOT EXISTS QnA(
                  id INTEGER PRIMARY KEY,
                  question TEXT,
                  answer TEXT
                );
            """
        )
        
//        ベクトルデータ保存用のテーブルを作成
        try await database.execute(
            """
                CREATE VIRTUAL TABLE IF NOT EXISTS embeddings USING vec0(
                  id INTEGER PRIMARY KEY,
                  embedding float[512]
                );
            """
        )
    }
    
    func save(qaEntry: QAEntry, embedding: Embedding) async throws {
        try await database.execute(
            """
                INSERT INTO QnA(question, answer) VALUES(?, ?);
            """,
            params: [qaEntry.question, qaEntry.answer]
        )
        
        let lastInsertRowId = await database.lastInsertRowId
        let vectorEmbeddings = embedding.vector.map { Float($0) }
        try await database.execute(
            """
                INSERT INTO embeddings(id, embedding)
                VALUES (?, ?);
            """,
            params: [lastInsertRowId, vectorEmbeddings]
        )
    }
    
    func vectorSimilar(to embedding: Embedding, k: Int = 1) async throws -> [QAEntry] {
        let vectorEmbeddings = embedding.vector.map { Float($0) }
        let result = try await database.query(
            """
                SELECT embeddings.id as id, question, answer
                FROM embeddings
                LEFT JOIN QnA ON QnA.id = embeddings.id
                WHERE embedding MATCH ? AND k = ?
                ORDER BY distance
            """,
            params: [vectorEmbeddings, k]
        )
        
        return result.compactMap(QAEntry.init)
    }
}
