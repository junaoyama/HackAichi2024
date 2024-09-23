//
//  GetBotResponseUsecase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import OpenAI

class GetBotResponseUseCaseImpl: AskChatBotUseCase {
    private let embeddingService: EmbeddingService
    private let qaEntryRepository: QAEntryRepository
    private let messageLogRepository: MessageLogRepository
    private let failureThreshold: Float = 0.3
    
    init(embeddingService: EmbeddingService = AppleEmbeddingService.shared, qaEntryRepository: QAEntryRepository = LocalRepositoryProviderService.shared.get(), messageLogRepository: MessageLogRepository = LocalRepositoryProviderService.shared.get()) {
        self.embeddingService = embeddingService
        self.qaEntryRepository = qaEntryRepository
        self.messageLogRepository = messageLogRepository
    }
    
    func askQuestion(_ message: Message) async throws -> ChatBotResponse {
//        質問を記録する
        try await messageLogRepository.save(message: message)
        let embedding = try await embeddingService.embed(text: message.content)
        var result = try await qaEntryRepository.vectorSimilar(to: embedding, k: 15)
        if result[0].distance > failureThreshold {
            return ChatBotResponse.fail
        }
        
        result = result.filter({ $0.distance < failureThreshold })
        let qaEntries = result.map({ $0.qaEntry })
        
        let ref = qaEntries.map({ "question: " + $0.question + ", " + "answer: " + $0.answer }).joined(separator: "\n")
        let answer = try await askLLM(question: message.content, context: ref)
        let answerMessage = Message(id: .init(), sender: .bot, content: answer, sentAt: Date())
//        答えを記録する
        try await messageLogRepository.save(message: answerMessage)
        return ChatBotResponse.success(answerMessage)
    }
}

extension GetBotResponseUseCaseImpl {
    func askLLM(question: String, context: String) async throws -> String {
        let apiToken: String = "unknown"
        let openAI = OpenAI(apiToken: apiToken)
        let query = ChatQuery(messages: [
            .assistant(.init(content:
                """
                あなたは社内情報に関する質問に答えるアシスタントです。以下の手順に従って回答を作成してください：

                1. **質問の分析**:
                   - ユーザーの現在の状態（変更前）と希望する状態（変更後）を正確に特定します。
                   - 変更の方向性を明確に認識し、誤解を避けるように注意してください。

                2. **回答の作成**:
                   - 提供された参考情報を用いて、ユーザーの要望に沿った具体的な回答を作成します。
                   - 回答は明確で簡潔にし、ユーザーが次に取るべき行動がわかるようにしてください。

                3. **ユーモアの追加**:
                   - 回答の後に、内容に関連した面白いユーモアや一言を付け加えてください。
                   - ユーモアは以下の条件を満たすものにしてください：
                     - **親しみやすいジョークや言葉遊びを用いる**
                     - **誰もが理解できるユーモア**
                     - **業務内容や状況に関連したもの**
                     - **不快にならない適切な内容**
                     - **軽い驚きや微笑みを誘うような表現**

                **注意事項**：

                - 回答は社内ポリシーに従って提供し、機密情報や公開すべきでない情報は含めないでください。
                - ユーザーには最終的な回答のみを表示し、要素質問や分析のプロセスは見せないでください。
                - プロフェッショナルな態度を保ちつつ、親しみやすい言葉遣いを心がけてください。
                """
            )),
            .user(.init(content: .string("質問: " + question + "\n" + "参考情報" + ": " + context)))], model: .gpt4_o_mini)
        let result = try await openAI.chats(query: query)
        let answer = result.choices.first!.message.content!.string!
        return answer
    }
}
