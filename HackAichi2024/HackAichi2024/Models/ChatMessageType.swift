//
//  ChatMessageType.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

// メッセージ
struct ChatMessageType: MessageType {
    var sender: SenderType  // 送信者
    var messageId: String  // メッセージID
    var kind: MessageKind  // メッセージ種別
    var sentDate: Date  // 送信日時

    // メッセージの生成
    static func new(sender: SenderType, message: String) -> ChatMessageType {
        return ChatMessageType(
            sender: sender,
            messageId: UUID().uuidString,
            kind: .attributedText(NSAttributedString(
                string: message,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14.0),
                    .foregroundColor: UIColor.cellText
                ]
            )),
            sentDate: Date())
    }
}
