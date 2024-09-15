//
//  ViewController.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/13.
//

import UIKit

class ViewController: UIViewController {
    
    var questionSendView: QuestionSendView!
    var goodButton: ReactionButton!
    var badButton: ReactionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        
        goodButton = ReactionButton(type: .good)
        self.view.addSubview(goodButton)
        badButton = ReactionButton(type: .bad)
        self.view.addSubview(badButton)
        
        questionSendView = QuestionSendView()
        self.view.addSubview(questionSendView)
        
        NSLayoutConstraint.activate([
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

