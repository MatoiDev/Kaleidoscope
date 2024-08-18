//
//  SettingsViewController.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 07.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit


protocol SettingsViewControllerPresenter: AnyObject {
    func dismissAndUpdateConfiguration(_ configuration: SettingsConfiguration) -> Void
}

class SettingsViewController: UIViewController {
    
    // Properties
    private let kandinskyService: KandinskyAPIService = KandinskyAPIService()
    private let careTaker: SettingsConfigurationCareTaker = SettingsConfigurationCareTaker()
    private var settingsConfiguration: SettingsConfiguration!
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadConfiguration()
        fetchStylesData()
    }
}


private extension SettingsViewController {
    
    func setupView() -> Void {
        let view: SettingsView = SettingsView()
        
        view.presenter = self
        
        self.view = view
    }
    
    func loadConfiguration() -> Void {
        do {
            settingsConfiguration = try careTaker.get()
            DispatchQueue.main.async {
                (self.view as? SettingsView)?.updateView(with: self.settingsConfiguration)
            }
        } catch {
            settingsConfiguration = SettingsConfiguration()
            print(error.localizedDescription)
        }
    }
    
    func fetchStylesData() {

        kandinskyService.fetchStyles { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let styles):
                DispatchQueue.main.async {
                    (self.view as? SettingsView)?.updatePickerView(with: styles)
                }
                
            case .failure(let error):
                let oldStyles: [KandinskyStyles] = [
                    KandinskyStyles(name: "KANDINSKY", titleEn: "Kandinsky", title: "Кандинский", image: "https://cdn.fusionbrain.ai/static/download/img-style-kandinsky.png"),
                    KandinskyStyles(name: "UHD", titleEn: "Detailed photo", title: "Детальное фото", image: "https://cdn.fusionbrain.ai/static/download/img-style-detail-photo.png"),
                    KandinskyStyles(name: "ANIME", titleEn: "Anime", title: "Аниме", image: "https://cdn.fusionbrain.ai/static/download/img-style-anime.png"),
                    KandinskyStyles(name: "DEFAULT", titleEn: "No style", title: "Свой стиль", image: "https://cdn.fusionbrain.ai/static/download/img-style-personal.png")
                ]
                
                DispatchQueue.main.async {
                    (self.view as? SettingsView)?.updatePickerView(with: oldStyles)
                }
                
                print("Failed to fetch styles: \(error.localizedDescription)")
            }
        }
    }
}

extension SettingsViewController: SettingsViewControllerPresenter {
    func dismissAndUpdateConfiguration(_ configuration: SettingsConfiguration) -> Void {
        do {
            try careTaker.save(configuration)
            dismiss(animated: true)
        } catch {
            fatalError("Can not save configuration.")
        }
    }
}
