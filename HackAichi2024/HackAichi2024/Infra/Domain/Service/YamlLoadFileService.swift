//
//  YamlLoadFileService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import Yams

class YamlLoadFileService: LoadFileService {
    func load(path: URL) -> [QAEntry] {
        var demoQAEntries: [QAEntry] = []
        let demoPath = path.relativePath
        do {
            // ファイルの内容を文字列として読み込む
            let yamlString = try String(contentsOfFile: demoPath, encoding: .utf8)
            // YAML文字列を辞書にパース
            if let yaml = try Yams.load(yaml: yamlString) as? [String: Any],
               let qaPairs = yaml["qa_pairs"] as? [[String: Any]] {
                // QとAのペアを取得
                for pair in qaPairs {
                    if let question = pair["question"] as? String {
                        var qaAnswer = ""
                        if let answer = pair["answer"] {
                            if let answerList = answer as? [String] {
                                qaAnswer = answerList.joined(separator: "\n")
                            } else if let answerString = answer as? String {
                                qaAnswer = answerString
                            }
                        }
                        demoQAEntries.append(QAEntry(question: question, answer: qaAnswer))
                    }
                }
            }
        } catch {
            print("YAMLの読み込みに失敗しました: \(error)")
        }
        return demoQAEntries
    }
}
