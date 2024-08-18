//
//  SettingsConfigurationCareTaker.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 09.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import Foundation



final class SettingsConfigurationCareTaker {
    private let decoder: JSONDecoder = JSONDecoder()
    private let encoder: JSONEncoder = JSONEncoder()
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    private let keySet: String = "settings_configuration"
    
    func save(_ configuration: SettingsConfiguration) throws -> Void {
        let data = try encoder.encode(configuration)
        userDefaults.set(data, forKey: keySet)
    }
    
    func get() throws -> SettingsConfiguration {
        guard let data = userDefaults.data(forKey: keySet),
              let configuration: SettingsConfiguration = try? decoder.decode(SettingsConfiguration.self, from: data)
        else { throw SettingsConfigurationErrors.notExists }
        
        return configuration
    }
}


extension SettingsConfigurationCareTaker {
    enum SettingsConfigurationErrors: Error {
        case notExists
    }
}
