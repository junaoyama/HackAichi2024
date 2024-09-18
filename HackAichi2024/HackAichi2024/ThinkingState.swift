//
//  ThinkingVCState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import UIKit

class ThinkingState: ChatBotState {
    var viewController: ChatBotViewController!
    
    init(viewController: ChatBotViewController!) {
        self.viewController = viewController
    }
    
    func activate() {
        viewController.userMessageView.text = viewController.userViewModel.inputText
        viewController.userMessageView.isHidden = false
        viewController.goodBadButton.isHidden = true
        viewController.questionSendView.isHidden = true
    }
    
    func deactivate() {
        print("ThinkingVCState tearDowm（未実装）")
    }
    
    func goNextState() {
        print("AnswerStateへ（未実装）")
    }
}
