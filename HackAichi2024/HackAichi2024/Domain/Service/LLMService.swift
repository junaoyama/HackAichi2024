//
//  LLMService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/10/06.
//

protocol LLMService {
    func askLLM(question: String, context: String) async throws -> String
}
