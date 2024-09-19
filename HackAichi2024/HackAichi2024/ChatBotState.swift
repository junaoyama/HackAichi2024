//
//  ViewControllerState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import Foundation

protocol ChatBotState {
    func activate()
    func deactivate()
    func goNextState()
}

enum ChatBotStateType {
    case welcome
    case thinking
    
    mutating func goNextStateType() {
        switch self {
        case .welcome:
            self = .thinking
        case .thinking:
            return
        }
    }
}
