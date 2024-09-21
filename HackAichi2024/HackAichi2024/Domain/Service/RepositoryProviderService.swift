//
//  DBManagedService.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

protocol RepositoryProviderService {
    func get() -> any QAEntryRepository
    func get() -> any MessageLogRepository
}
