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
    private init() {}
    static let shared: LocalQAEntryRepository = .init()
//    遅延評価させないと落ちる(SQLiteVec.initialize()の前にDatabaseクラスを使用してはいけない)
    private lazy var database: Database = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = path.appendingPathComponent("myDatabase.sqlite").path
        return try! Database(.uri(dbPath))
    }()
    
    private var needSetUp: Bool = true

    private func setUpIfNeed() async throws {
        if !needSetUp {
            return
        }
        
        try SQLiteVec.initialize()
        
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
        
        needSetUp = false
    }
    
    func save(qaEntry: QAEntry, embedding: Embedding) async throws {
        try await setUpIfNeed()
        
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
    
    func vectorSimilar(to embedding: Embedding, k: Int = 1) async throws -> [QAEntry] {
        try await setUpIfNeed()
        
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
        
        return result.compactMap(QAEntry.init)
    }
}
