//
//  UIImage.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/22.
//

import UIKit
import SwiftyGif

extension UIImage {
    // SwiftyGifではimageDataにgif情報を入れている
    var isGif: Bool {
        return self.imageData != nil
    }
}
