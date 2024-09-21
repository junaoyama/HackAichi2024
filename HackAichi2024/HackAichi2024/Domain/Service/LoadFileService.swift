//
//  LoadDataService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/16.
//

import Foundation


protocol LoadFileService {
    func load(path: URL) throws -> [QAEntry]
}
