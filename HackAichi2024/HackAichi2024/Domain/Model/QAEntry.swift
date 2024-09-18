//
//  QA.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/15.
//

import Foundation

//質問と回答、およびそのベクトル表現を保持する。
struct QAEntry: Codable {
    let question: String
    let answer: String //もっと構造を持たせるのもあり
}

extension QAEntry {
    init?(_ result: [String: Any]) {
        guard let question = result["question"] as? String else {
            return nil
        }
        guard let answer = result["answer"] as? String else {
            return nil
        }
        self.init(question: question, answer: answer)
    }
}

