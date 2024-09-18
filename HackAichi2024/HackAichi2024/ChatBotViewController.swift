//
//  ViewController.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/13.
//

import UIKit

class ChatBotViewController: UIViewController {
    var state: ChatBotState! {
        willSet {
            state.tearDown()
        }
        didSet {
            state.setUp()
        }
    }
    var userViewModel: UserMessageViewModel!
    private var userMessageViewLayoutGuide: UILayoutGuide!
    private var characterImageView: CharacterImageView!
    private var characterMessageView: CharacterMessageView!
    var userMessageView: UserMessageView!
    var goodBadButton: GoodBadButton!
    var questionSendView: QuestionSendView!
    
    private var questionSendViewKeyboardHiddenLayout: [NSLayoutConstraint]!
    private var questionSendViewKeyboardVisibleLayout: [NSLayoutConstraint]!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        state = WelcomeState(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        userViewModel = UserMessageViewModel()
        
        userMessageViewLayoutGuide = UILayoutGuide()
        self.view.addLayoutGuide(userMessageViewLayoutGuide)
        
        characterImageView = CharacterImageView(image: UIImage(named: "chatbot_charactor_1"))
        view.addSubview(characterImageView)
        
        characterMessageView = CharacterMessageView()
        view.addSubview(characterMessageView)
        
        userMessageView = UserMessageView()
        view.addSubview(userMessageView)
        
        goodBadButton = GoodBadButton()
        self.view.addSubview(goodBadButton)
        
        questionSendView = QuestionSendView()
        questionSendView.sendButton.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
        self.view.addSubview(questionSendView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setUpNotification()
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            characterImageView.bottomAnchor.constraint(equalTo: characterMessageView.topAnchor, constant: -15),
            characterImageView.leadingAnchor.constraint(equalTo: userMessageViewLayoutGuide.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: userMessageViewLayoutGuide.trailingAnchor),
            
            characterMessageView.heightAnchor.constraint(equalTo: characterImageView.heightAnchor),
            characterMessageView.bottomAnchor.constraint(equalTo: userMessageView.topAnchor, constant: -15),
            characterMessageView.leadingAnchor.constraint(equalTo: userMessageViewLayoutGuide.leadingAnchor),
            characterMessageView.trailingAnchor.constraint(equalTo: userMessageViewLayoutGuide.trailingAnchor),
            
            userMessageViewLayoutGuide.heightAnchor.constraint(equalTo: characterImageView.heightAnchor),
            userMessageViewLayoutGuide.bottomAnchor.constraint(equalTo: goodBadButton.topAnchor, constant: -15),
            userMessageViewLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userMessageViewLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            userMessageView.topAnchor.constraint(equalTo: userMessageViewLayoutGuide.topAnchor),
            userMessageView.bottomAnchor.constraint(equalTo: userMessageViewLayoutGuide.bottomAnchor),
            userMessageView.leadingAnchor.constraint(equalTo: userMessageViewLayoutGuide.leadingAnchor),
            userMessageView.trailingAnchor.constraint(equalTo: userMessageViewLayoutGuide.trailingAnchor),
            
            goodBadButton.widthAnchor.constraint(equalToConstant: 160),
            goodBadButton.heightAnchor.constraint(equalToConstant: 40),
            goodBadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            goodBadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
        ])
        
        questionSendViewKeyboardHiddenLayout = [
            questionSendView.heightAnchor.constraint(equalToConstant: 45),
            questionSendView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            questionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        
        questionSendViewKeyboardVisibleLayout = [
            questionSendView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 10),
            questionSendView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            questionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(questionSendViewKeyboardHiddenLayout)
        
        state = WelcomeState(viewController: self)
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapSendButton(_ sender: UIButton) {
        state.goNextState()
    }
    
    @objc private func keyboardWillShow(_ sender: NSNotification) {
        NSLayoutConstraint.deactivate(questionSendViewKeyboardHiddenLayout)
        questionSendView.setKeyboardVisibleLayout()
        NSLayoutConstraint.activate(questionSendViewKeyboardVisibleLayout)
    }
    
    @objc private func keyboardWillHide(_ sender: NSNotification) {
        NSLayoutConstraint.deactivate(questionSendViewKeyboardVisibleLayout)
        questionSendView.setKeyboardHiddenLayout()
        NSLayoutConstraint.activate(questionSendViewKeyboardHiddenLayout)
    }
}

