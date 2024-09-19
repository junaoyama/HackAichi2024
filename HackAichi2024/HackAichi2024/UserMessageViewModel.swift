//
//  UserViewModel.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import Foundation

class UserMessageViewModel {
    var stateType: ChatBotStateType
    var inputText: String?
    
    init(stateType: ChatBotStateType, inputText: String? = nil) {
        self.stateType = stateType
        self.inputText = inputText
    }
}
