//
//  AppleEmbeddingService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import NaturalLanguage
// ベクトルの計算を扱う線形代数フレームワーク
import Accelerate

class AppleEmbeddingService: EmbeddingService {
    private init() {}
    static let shared: AppleEmbeddingService = .init()
    //これが取得できていないとアプリが成立しないので落とす
    private lazy var embeddingProvider: NLContextualEmbedding = {
        NLContextualEmbedding(language: .japanese)!
    }()
    
    private var needSetUp: Bool = true
    
    private func setUpIfNeed() async throws {
        if !needSetUp {
            return
        }
        
        if embeddingProvider.hasAvailableAssets {
            try? embeddingProvider.load()
        } else {
            try await embeddingProvider.requestAssets()
        }
    }
    
    func embed(text: String) async throws -> Embedding {
        var text = text.trimmingCharacters(in: .whitespaces)
        try await setUpIfNeed()
        
        if Task.isCancelled {
            throw AppError.tooManyVectorSearchRequest
        }
        
        let embeddingResult = try embeddingProvider.embeddingResult(for: text, language: .japanese)
        // ゼロベクトルを用意
        var meanPooledEmbeddings = Array<Float>(repeating: 0, count: embeddingProvider.dimension)
        // トークンのベクトルを足し合わせる
        embeddingResult.enumerateTokenVectors(in: text.startIndex ..< text.endIndex) { (embedding, _) -> Bool in
            meanPooledEmbeddings = vDSP.add(meanPooledEmbeddings, vDSP.doubleToFloat(embedding))
            return true
        }
        let sequenceLength = embeddingResult.sequenceLength
        if sequenceLength > 0 {
            // 足したベクトルをトークン数で割る(トークン平均を文章のベクトルとみなす)
            return Embedding(vector: vDSP.divide(meanPooledEmbeddings, Float(sequenceLength)))
        }
        
        return Embedding(vector: meanPooledEmbeddings)
    }
}
