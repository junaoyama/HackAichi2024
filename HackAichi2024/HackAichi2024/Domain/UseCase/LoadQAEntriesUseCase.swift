//
//  ConnectDBUseCase.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation
import Yams
import Accelerate

protocol LoadQAEntriesUseCase {
    func loadIfNeed() async throws
}
