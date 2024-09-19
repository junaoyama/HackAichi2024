//
//  QuestionSendViewModel.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/19.
//

import Foundation

class QuestionSendViewModel {
    var stateType: ChatBotStateType
    var inputText: String?
    
    init(stateType: ChatBotStateType, inputText: String? = nil) {
        self.stateType = stateType
        self.inputText = inputText
    }
}

