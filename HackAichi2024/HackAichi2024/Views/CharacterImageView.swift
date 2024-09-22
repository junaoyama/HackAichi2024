//
//  CharactorImageView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit
import SwiftyGif

class CharacterImageView: UIImageView {
    
    init(viewModel: CharacterImageViewModel) {
        super.init(frame: .zero)
        setUpImageView()
        apply(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImageView() {
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func apply(viewModel: CharacterImageViewModel) {
        switch viewModel.type {
        case .image:
            self.setImage(viewModel.image)
        case .gif:
            self.setGifImage(viewModel.image)
        }
    }
}
