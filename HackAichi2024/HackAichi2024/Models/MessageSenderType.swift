//
//  MessageSenderType.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

// 送信者
struct MessageSenderType: SenderType {
    var senderId: String  // 送信者ID
    var displayName: String  // 表示名
    var iconName: String  // アイコン名

    // 自分のSenderType
    static var user: MessageSenderType {
        return MessageSenderType(senderId: "0", displayName: "user", iconName: "person")
    }

    // 他人のSenderType
    static var character: MessageSenderType {
        return MessageSenderType(senderId: "1", displayName: "character", iconName: "person.fill")
    }
}
