//
//  ThinkingVCState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import UIKit

class ThinkingState: ChatBotState {
    weak var viewController: ChatBotViewController!
    
    init(viewController: ChatBotViewController!) {
        self.viewController = viewController
    }
    
    func activate() {
        viewController.userMessageViewModel.inputText = viewController.questionSendViewModel.inputText
        viewController.userMessageView.activateViewBy(viewModel: viewController.userMessageViewModel)
        viewController.goodBadButton.activateViewBy(viewModel: viewController.goodBadButtonViewModel)
        viewController.questionSendView.activateViewBy(viewModel: viewController.questionSendViewModel)
    }
    
    func deactivate() {
        print("ThinkingVCState tearDowm（未実装）")
    }
    
    func goNextState() {
        print("AnswerStateへ（未実装）")
    }
}
