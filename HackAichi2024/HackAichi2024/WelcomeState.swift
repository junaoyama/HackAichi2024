//
//  WelcomeVCState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import UIKit

class WelcomeState: ChatBotState {
    weak var viewController: ChatBotViewController!
    
    init(viewController: ChatBotViewController!) {
        self.viewController = viewController
    }
    
    func activate() {
        viewController.userMessageView.activateViewBy(viewModel: viewController.userMessageViewModel)
        viewController.goodBadButton.activateViewBy(viewModel: viewController.goodBadButtonViewModel)
        viewController.questionSendView.activateViewBy(viewModel: viewController.questionSendViewModel)
    }
    
    func deactivate() {
        viewController.userMessageView.deactivateViewBy(viewModel: viewController.userMessageViewModel)
        viewController.goodBadButton.deactivateViewBy(viewModel: viewController.goodBadButtonViewModel)
        viewController.questionSendView.deactivateViewBy(viewModel: viewController.questionSendViewModel)
        viewController.view.endEditing(true)
    }
    
    func goNextState() {
        viewController.stateType = .thinking
    }

}
