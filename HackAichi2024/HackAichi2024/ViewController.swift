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
    
    private var questionSendViewNoKeyboardLayout: [NSLayoutConstraint]!
    private var questionSendViewExsistKeyboardLayout: [NSLayoutConstraint]!
    

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
        
        setUpNotification()
        
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
            goodBadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            goodBadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
        ])
        
        questionSendViewNoKeyboardLayout = [
            questionSendView.heightAnchor.constraint(equalToConstant: 45),
            questionSendView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            questionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        
        questionSendViewExsistKeyboardLayout = [
            questionSendView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 10),
            questionSendView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            questionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(questionSendViewNoKeyboardLayout)
        
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ sender: NSNotification) {
        NSLayoutConstraint.deactivate(questionSendViewNoKeyboardLayout)
        NSLayoutConstraint.activate(questionSendViewExsistKeyboardLayout)
    }
    
    @objc private func keyboardWillHide(_ sender: NSNotification) {
        NSLayoutConstraint.deactivate(questionSendViewExsistKeyboardLayout)
        NSLayoutConstraint.activate(questionSendViewNoKeyboardLayout)
    }
}

