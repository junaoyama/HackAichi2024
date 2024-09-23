//
//  LocalDatabase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

//SQlite-vssに関するドキュメント
//https://github.com/asg017/sqlite-vec/blob/main/site/api-reference.md
//https://github.com/asg017/sqlite-vec/blob/main/site/features/knn.md

import Foundation
import SQLiteVec
import Accelerate

actor LocalQAEntryRepository: QAEntryRepository {
    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func save(qaEntry: QAEntry, embedding: Embedding) async throws {
        try await createTableIfNeed()
        
        try await database.execute(
            """
                INSERT INTO QnA(question, answer) VALUES(?, ?);
            """,
            params: [qaEntry.question, qaEntry.answer]
        )
//        QnAテーブルとembeddigテーブルのidを一致させるのに使用
        let lastInsertRowId = await database.lastInsertRowId
        let vectorEmbeddings = embedding.vector
        try await database.execute(
            """
                INSERT INTO embeddings(id, vector)
                VALUES (?, ?);
            """,
            params: [lastInsertRowId, vectorEmbeddings]
        )
    }
    
    func vectorSimilar(to embedding: Embedding, k: Int = 1) async throws -> [(qaEntry: QAEntry, distance: Float)] {
        try await createTableIfNeed()
        
        let vectorEmbeddings = embedding.vector
        let result = try await database.query(
            """
                SELECT
                    embeddings.id as id, question, answer, vec_distance_cosine(vector, ?) as distance
                from embeddings
                LEFT JOIN QnA ON QnA.id = embeddings.id
                order by distance
                Limit ?;
            """,
            params: [vectorEmbeddings, k]
        )
        
        return result.compactMap {
            if let distance = $0["distance"] as? Double, let qaEntry = QAEntry.init($0) {
                return (qaEntry, Float(distance))
            }
            return nil
        }
    }
    
    private func createTableIfNeed() async throws {
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
                  vector float[512]
                );
            """
        )
    }
}
