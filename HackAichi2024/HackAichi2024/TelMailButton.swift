//
//  TelMailButton.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

enum ContactType {
    case tel
    case mail
}

fileprivate class SelectableButton: UIButton {
    private var contactType: ContactType
    private var title: String {
        switch contactType {
        case .tel:
            return "電話をかける"
        case .mail:
            return "メールを作成する"
        }
    }
    
    init(type: ContactType) {
        contactType = type
        super.init(frame: .zero)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton() {
        self.backgroundColor = .systemBlue
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

class TelMailButton: UIStackView {

    private var telButton: SelectableButton!
    private var mailButton: SelectableButton!
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 20
        self.translatesAutoresizingMaskIntoConstraints = false
        
        telButton = SelectableButton(type: .tel)
        self.addArrangedSubview(telButton)
        
        mailButton = SelectableButton(type: .mail)
        self.addArrangedSubview(mailButton)
    }
}
