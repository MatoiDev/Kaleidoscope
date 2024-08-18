//
//  MainViewController.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 07.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit

protocol MainViewControllerPresenter: AnyObject {
    func presentSettings() -> Void
    func startStream() -> Void
}

final class MainViewController: UIViewController {
    
    private let careTaker: SettingsConfigurationCareTaker = SettingsConfigurationCareTaker()
    private var settingsConfiguration: SettingsConfiguration!
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}


private extension MainViewController {
    func setupView() -> Void {
        let view: MainView = MainView()
        
        view.presenter = self
        
        self.view = view
    }
    
    func raiseAlert(title: String, message: String) -> Void {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAlertAction)
        present(alert, animated: true)
    }
}

extension MainViewController: MainViewControllerPresenter {
    func startStream() {
        do {
            let configuration: SettingsConfiguration = try careTaker.get()
            var logDetails: [String] = []
            
            if let apiKey: String = configuration.state.apiKey, apiKey.isEmpty { logDetails.append("• Empty API key field"); }
            if let secretKey = configuration.state.secretKey, secretKey.isEmpty { logDetails.append("• Empty Secret key field") }
            if let prompt = configuration.state.prompt, prompt.isEmpty { logDetails.append("• Empty Prompt key field") }
            
            guard logDetails.isEmpty else { raiseAlert(title: "Warning", message: logDetails.joined(separator: "\n")); return }
            
            presentStreamViewController(with: configuration)
            
        } catch {
            raiseAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    func presentSettings() {
        let viewController: SettingsViewController = SettingsViewController()
        viewController.modalPresentationStyle = .formSheet
        present(viewController, animated: true)
    }
    
    private func presentStreamViewController(with configuration: SettingsConfiguration) -> Void {
        let viewController: StreamViewController = StreamViewController(configuration: configuration)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
