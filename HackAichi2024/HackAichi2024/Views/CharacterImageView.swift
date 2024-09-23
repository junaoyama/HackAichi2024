//
//  CharactorImageView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit
import SwiftyGif

class CharacterImageView: UIImageView {
    private var animationTask: Task<Void, Error>?
    var interval: Double = 0
    
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
            self.setGifImage(viewModel.image, loopCount: viewModel.loopCount)
            self.interval = viewModel.interval
            self.delegate = self
        }
        animationTask?.cancel()
        self.startAnimatingGif()
    }
}

extension CharacterImageView: SwiftyGifDelegate {
    func gifDidLoop(sender: UIImageView) {
        let characterImageView = sender as! CharacterImageView
        if characterImageView.interval != 0 {
            sender.stopAnimatingGif()
            animationTask?.cancel()
            animationTask = Task {
                try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                sender.startAnimatingGif() // 再びGIFを再生
            }
        }
    }
}
