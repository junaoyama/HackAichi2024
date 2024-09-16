//
//  ViewController.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/13.
//

import UIKit

class ViewController: UIViewController {
    private var stackView: UIStackView!
    private var characterImageView: CharacterImageView!
    private var characterMessageView: CharacterMessageView!
    private var userMessageView: UserMessageView!
//    private var telMailButton: TelMailButton!
    private var goodBadButton: GoodBadButton!
    private var questionSendView: QuestionSendView!
    

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
        
        characterMessageView = CharacterMessageView()
        stackView.addArrangedSubview(characterMessageView)
        
        userMessageView = UserMessageView()
        stackView.addArrangedSubview(userMessageView)
        
        self.view.addSubview(stackView)
        
        
        goodBadButton = GoodBadButton()
        self.view.addSubview(goodBadButton)
        
        questionSendView = QuestionSendView()
        self.view.addSubview(questionSendView)
        
        //telMailButtonは一旦ゴリ押しで置いてます
//        telMailButton = TelMailButton()
//        self.view.addSubview(telMailButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            //telMailButtonは一旦ゴリ押しで置いてます
//            telMailButton.heightAnchor.constraint(equalToConstant: 30),
//            telMailButton.leadingAnchor.constraint(equalTo: questionSendView.leadingAnchor, constant: 15),
//            telMailButton.trailingAnchor.constraint(equalTo: questionSendView.trailingAnchor, constant: -15),
//            telMailButton.bottomAnchor.constraint(equalTo: goodBadButton.topAnchor, constant: -200),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: goodBadButton.topAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            goodBadButton.widthAnchor.constraint(equalToConstant: 160),
            goodBadButton.heightAnchor.constraint(equalToConstant: 40),
            goodBadButton.trailingAnchor.constraint(equalTo: questionSendView.trailingAnchor),
            goodBadButton.bottomAnchor.constraint(equalTo: questionSendView.topAnchor, constant: -15),
            
            questionSendView.heightAnchor.constraint(equalToConstant: 45),
            questionSendView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            questionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  
    }
}

