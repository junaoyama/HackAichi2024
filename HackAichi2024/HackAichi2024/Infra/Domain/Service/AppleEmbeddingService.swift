//
//  AppleEmbeddingService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import NaturalLanguage

class AppleEmbeddingService: EmbeddingService {
    var embeddingProvider = NLEmbedding.sentenceEmbedding(for: .japanese)
    
    func embed(text: String) async throws -> Embedding {
        guard let embeddingProvider else {
            fatalError("ここでエラーを返す")
        }
        
        guard let embedding = embeddingProvider.vector(for: text) else {
            fatalError("ここでエラーを返す")
        }
        
        return Embedding(vector: embedding)
    }
}
