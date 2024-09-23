//
//  Embedding.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import Accelerate

struct Embedding: Codable {
    let vector: [Float]
}

extension Embedding {
    func l2Distance(other: Embedding) -> Float? {
        // ベクトルの要素数が一致しているか確認
        guard self.vector.count == other.vector.count else {
            print("ベクトルのサイズが一致していません")
            return nil
        }
        
        // 差分ベクトルを格納する配列を用意
        var diff = [Float](repeating: 0, count: self.vector.count)
        
        // ベクトル同士の差分を計算
        vDSP_vsub(other.vector, 1, self.vector, 1, &diff, 1, vDSP_Length(self.vector.count))
        
        // 差分ベクトルの二乗和を計算
        var sumOfSquares: Float = 0.0
        vDSP_svesq(diff, 1, &sumOfSquares, vDSP_Length(self.vector.count))
        
        // 二乗和の平方根を取ってL2距離を返す
        return sumOfSquares
    }
}
