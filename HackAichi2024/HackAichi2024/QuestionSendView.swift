//
//  SendQuestionView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

class QuestionSendView: UIView {
    private var questionTextView: UITextView!
    private var sendButton: UIButton!
    
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
        
        NSLayoutConstraint.activate([
            questionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            questionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            questionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            questionTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.topAnchor.constraint(equalTo: questionTextView.topAnchor),
            sendButton.bottomAnchor.constraint(equalTo: questionTextView.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
    }

}
