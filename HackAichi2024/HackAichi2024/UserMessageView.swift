//
//  MessageTextView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

class UserMessageView: UITextView {
    init() {
        super.init(frame: .zero, textContainer: nil)
        setUpTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextView() {
        self.backgroundColor = .systemGreen
        self.isEditable = false
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func activateViewBy(viewModel: UserMessageViewModel) {
        switch viewModel.stateType {
        case .welcome:
            self.isHidden = true
        case .thinking:
            self.text = viewModel.inputText
            self.isHidden = false
        }
    }
    
    func deactivateViewBy(viewModel: UserMessageViewModel) {
        switch viewModel.stateType {
        case .welcome:
            break
        case .thinking:
            print("deactivateUserMessageViewBy（未実装）")
        }
        viewModel.stateType.goNextStateType()
    }
}
