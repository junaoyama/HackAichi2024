//
//  Message.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/15.
//

import Foundation

struct Message {
    let id: UUID
    let sender: Sender
    let content: String
    let timestamp: Date

    enum Sender {
        case user
        case bot
    }
}
