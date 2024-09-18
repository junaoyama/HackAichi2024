//
//  EmbeddingService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import NaturalLanguage

protocol EmbeddingProvider {
    func vector(for string: String) -> [Double]?
}

extension NLEmbedding: EmbeddingProvider {}

protocol EmbeddingService {
    /// テキストをベクトル化（埋め込み）するメソッド
    /// - Parameters:
    ///   - text: 埋め込み対象のテキスト
    ///   - completion: ベクトル化の結果を返すクロージャ。成功時には埋め込みデータを、失敗時にはエラーを返します。
    func embed(text: String) async throws -> Embedding
}
