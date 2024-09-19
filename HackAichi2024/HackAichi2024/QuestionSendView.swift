//
//  SendQuestionView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

class QuestionSendView: UIView {
    var questionTextView: UITextView!
    var sendButton: UIButton!
    private var keyboardHiddenEmptyTextConstraints: [NSLayoutConstraint]!
    private var keyboardHiddenWithTextConstraints: [NSLayoutConstraint]!
    private var keyboardVisibleLayoutConstraints: [NSLayoutConstraint]!
    
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.backgroundColor = .systemGray4
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        
        questionTextView = UITextView()
        questionTextView.backgroundColor = .systemGray5
        questionTextView.textColor = .black
        questionTextView.font = UIFont.systemFont(ofSize: 16)
        questionTextView.layer.cornerRadius = 20
        questionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(questionTextView)
        
        sendButton = UIButton()
        sendButton.backgroundColor = .systemBlue
        sendButton.setTitle("送信", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 20
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sendButton)
        
        keyboardHiddenEmptyTextConstraints = [
            questionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            questionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            questionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            questionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ]
        
        keyboardHiddenWithTextConstraints = [
            questionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            questionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            questionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            questionTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.heightAnchor.constraint(equalToConstant: 35),
            sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ]
        
        keyboardVisibleLayoutConstraints = [
            questionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            questionTextView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -5),
            questionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            questionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            sendButton.heightAnchor.constraint(equalToConstant: 35),
            sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ]
        
        setKeyboardHiddenLayout()
    }
    
    func setKeyboardHiddenLayout() {
        NSLayoutConstraint.deactivate(keyboardVisibleLayoutConstraints)
        if questionTextView.text == "" {
            sendButton.isHidden = true
            NSLayoutConstraint.activate(keyboardHiddenEmptyTextConstraints)
        } else {
            NSLayoutConstraint.activate(keyboardHiddenWithTextConstraints)
            sendButton.isHidden = false
        }
    }

    
    func setKeyboardVisibleLayout() {
        if questionTextView.text == "" {
            NSLayoutConstraint.deactivate(keyboardHiddenEmptyTextConstraints)
        } else {
            NSLayoutConstraint.deactivate(keyboardHiddenWithTextConstraints)
        }
        NSLayoutConstraint.activate(keyboardVisibleLayoutConstraints)
        sendButton.isHidden = false
    }
    
    func activateViewBy(viewModel: QuestionSendViewModel) {
        switch viewModel.stateType {
        case .welcome:
            return
        case .thinking:
            self.isHidden = true
        }
    }
    
    func deactivateViewBy(viewModel: QuestionSendViewModel) {
        switch viewModel.stateType {
        case .welcome:
            viewModel.inputText = questionTextView.text
        case .thinking:
            print("deactivateUserMessageViewBy（未実装）")
        }
        viewModel.stateType.goNextStateType()
    }

}
