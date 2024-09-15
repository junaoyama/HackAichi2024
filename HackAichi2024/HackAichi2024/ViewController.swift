//
//  ViewController.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/13.
//

import UIKit

class ViewController: UIViewController {
    var stackView: UIStackView!
    var characterImageView: CharacterImageView!
    var characterMessageTextView: MessageTextView!
    var myMessageTextView: MessageTextView!
    var goodButton: ReactionButton!
    var badButton: ReactionButton!
    var questionSendView: QuestionSendView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        characterImageView = CharacterImageView(image: UIImage(named: "chatbot_charactor_1"))
        stackView.addArrangedSubview(characterImageView)
        
        characterMessageTextView = MessageTextView(sender: .character)
        stackView.addArrangedSubview(characterMessageTextView)
        
        myMessageTextView = MessageTextView(sender: .myself)
        stackView.addArrangedSubview(myMessageTextView)
        
        self.view.addSubview(stackView)
        
        goodButton = ReactionButton(type: .good)
        self.view.addSubview(goodButton)
        badButton = ReactionButton(type: .bad)
        self.view.addSubview(badButton)
        
        questionSendView = QuestionSendView()
        self.view.addSubview(questionSendView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: goodButton.topAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            goodButton.widthAnchor.constraint(equalToConstant: 70),
            goodButton.heightAnchor.constraint(equalToConstant: 40),
            goodButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            goodButton.bottomAnchor.constraint(equalTo: questionSendView.topAnchor, constant: -15),
            
            badButton.widthAnchor.constraint(equalTo: goodButton.widthAnchor),
            badButton.heightAnchor.constraint(equalTo: goodButton.heightAnchor),
            badButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            badButton.bottomAnchor.constraint(equalTo: goodButton.bottomAnchor),
            
            questionSendView.heightAnchor.constraint(equalToConstant: 45),
            questionSendView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            questionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}

