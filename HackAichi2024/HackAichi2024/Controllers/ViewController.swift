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
    private var goodBadButton: GoodBadButton!
    

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
        
        self.view.addSubview(stackView)
        
        goodBadButton = GoodBadButton()
        self.view.addSubview(goodBadButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: goodBadButton.topAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            goodBadButton.widthAnchor.constraint(equalToConstant: 160),
            goodBadButton.heightAnchor.constraint(equalToConstant: 40),
            goodBadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            goodBadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
        ])
        
    }
}

