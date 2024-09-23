//
//  RecommendUseCase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/23.
//

import Foundation

protocol RecommendUseCase {
    func recommend(from message: String) async throws -> String
}
