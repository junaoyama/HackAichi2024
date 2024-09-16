//
//  QARepository.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/15.
//

import Foundation

//QAEntryとEmbeddingの組みをDBに保存する・特定の類似度に従ってEmbeddingに近いQAEntryを返す
protocol QAEntryRepository {
    func setUpDB() async throws
    func save(qaEntry: QAEntry, embedding: Embedding) async throws
    func vectorSimilar(to embedding: Embedding, k: Int) async throws -> [QAEntry]
}

