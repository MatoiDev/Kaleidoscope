//
//  SettingsConfiguration.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 09.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import Foundation


final class SettingsConfiguration: Codable {
    final class State: Codable {
        var apiKey: String?
        var secretKey: String?
        var prompt: String?
        var negativePrompt: String?
        var style: String?
        var interval: Double = 30.0
    }
    
    var state: State = State()
    
    func setApiKey(_ key: String?) -> Void {
        state.apiKey = key
    }
    
    func setSecretKey(_ key: String?) -> Void {
        state.secretKey = key
    }
    
    func updatePrompt(_ prompt: String?) -> Void {
        state.prompt = prompt
    }
    
    func updateNegativePrompt(_ prompt: String?) -> Void {
        state.negativePrompt = prompt
    }
    
    func setStyle(_ style: KandinskyStyles?) -> Void {
        state.style = style?.name ?? "DEFAULT"
    }
    
    func updateInterval(_ interval: String?) -> Void {
        guard let unwrappedInterval: String = interval, let interval: Double = Double(unwrappedInterval) else {
            state.interval = 30.0
            return
        }
        state.interval = interval
    }
}
