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
        //user
        if sender.senderId == "0" {
            return ChatMessageType(
                sender: sender,
                messageId: UUID().uuidString,
                kind: .attributedText(NSAttributedString(
                    string: message,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 18.0),
                        .foregroundColor: BuzzBotColors.cellText
                    ]
                )),
                sentDate: Date())
        } else {
            return ChatMessageType(
                sender: sender,
                messageId: UUID().uuidString,
                kind: .custom(NSAttributedString(
                    string: message,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 18.0),
                        .foregroundColor: BuzzBotColors.cellText
                    ]
                )),
                sentDate: Date())
        }
        
    }
}
