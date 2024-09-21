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
    let sentAt: Date

    enum Sender: Int {
        case user //0
        case bot //1
    }
}
