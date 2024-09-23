//
//  RecommendView.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/23.
//

import Foundation
import UIKit

class RecommendView: UIView {
    private let label = UILabel()
    var padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraintsForPadding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraintsForPadding()
    }

    private func setupView() {
//        背景色の設定
        self.backgroundColor = .white
        // 角丸の設定
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
    
        // 影の設定
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4

        // ラベルの設定
        label.text = ""
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        // ラベルをビューに追加
        self.addSubview(label)
        
        setupConstraintsForPadding()
    }
    
    override func layoutSubviews() {
        self.isHidden = (self.label.text ?? "").isEmpty
    }

    private func setupConstraintsForPadding() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding.bottom),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding.right)
        ])
    }
    
    func set(text: String) {
        self.label.text = text
    }
}
