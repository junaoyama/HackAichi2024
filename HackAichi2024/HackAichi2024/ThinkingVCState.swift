//
//  ThinkingVCState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import UIKit

class ThinkingVCState: ViewControllerState {
    var viewController: ViewController!
    
    init(viewController: ViewController!) {
        self.viewController = viewController
    }
    
    func setUp() {
        viewController.userMessageView.text = viewController.userViewModel.inputText
        viewController.userMessageView.isHidden = false
        viewController.goodBadButton.isHidden = true
        viewController.questionSendView.isHidden = true
    }
    
    func tearDown() {
        print("ThinkingVCState tearDowm（未実装）")
    }
    
    func goNextState() {
        print("AnswerStateへ（未実装）")
    }
}
