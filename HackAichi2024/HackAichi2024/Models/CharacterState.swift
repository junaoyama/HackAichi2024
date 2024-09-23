//
//  CharacterState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/22.
//

import Foundation

enum CharacterState {
    case welcome
    case thinking
    case answer
    case unknown
    
    mutating func goNextState(response: ChatBotResponse? = nil) {
        switch self {
        case .welcome:
            self = .thinking
        case .thinking:
            switch response {
            case .success(_):
                self = .answer
            case .fail:
                self = .unknown
            case nil:
                self = .unknown
            }
        case .answer:
            self = .thinking
        case .unknown:
            self = .thinking
        }
    }
}
