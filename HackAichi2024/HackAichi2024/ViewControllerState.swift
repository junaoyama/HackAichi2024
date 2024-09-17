//
//  ViewControllerState.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/17.
//

import Foundation

protocol ViewControllerState {
    func setUp()
    func tearDown()
    func goNextState()
}
