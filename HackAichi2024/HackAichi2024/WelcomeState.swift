//
//  WelcomeVCState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import UIKit

class WelcomeState: ChatBotState {
    var viewController: ChatBotViewController!
    
    init(viewController: ChatBotViewController!) {
        self.viewController = viewController
    }
    
    func activate() {
        viewController.userMessageView.isHidden = true
        viewController.goodBadButton.isHidden = true
    }
    
    func deactivate() {
        viewController.userViewModel.inputText = viewController.questionSendView.questionTextView.text
        viewController.view.endEditing(true)
    }
    
    func goNextState() {
        viewController.state = ThinkingState(viewController: viewController)
    }
    
    
}
