//
//  MockLLMService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/10/06.
//

class MockLLMService: LLMService {
    private init() {}
    static var shared: MockLLMService = .init()
    func askLLM(question: String, context: String) async throws -> String {
        return question + "が質問されたヨ！"
    }
}
