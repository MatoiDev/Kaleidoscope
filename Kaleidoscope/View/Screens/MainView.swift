//
//  MainView.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 07.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit

final class MainView: UIView {
    
    // Elements
    private let imageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let buttonsStackView: UIStackView = UIStackView()
    private let startButton: KaleidoscopeCustomButton = KaleidoscopeCustomButton(style: .plain, title: "Start", action: #selector(start))
    private let settingsButton: KaleidoscopeCustomButton = KaleidoscopeCustomButton(style: .outlined, title: "Settings", action: #selector(settings))
    
    weak var presenter: MainViewControllerPresenter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureButtonsStackView()
        configureDescriptionLabel()
        configureNameLabel()
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension MainView {
    
    func configure() -> Void {
        backgroundColor = .white
    }
    
    func configureButtonsStackView() -> Void {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 16.0
        
        buttonsStackView.addArrangedSubview(settingsButton)
        buttonsStackView.addArrangedSubview(startButton)
        
        addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.0),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.0),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32.0),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureDescriptionLabel() -> Void {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .systemGray
        descriptionLabel.text = "Your old iPad has become a window into a parallel universe."
        descriptionLabel.font = .systemFont(ofSize: 32.0, weight: .regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 2
        
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -64.0)
        ])
    }
    
    func configureNameLabel() -> Void {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.text = "Kaleidoscope"
        nameLabel.font = .systemFont(ofSize: 54.0, weight: .bold)
        nameLabel.textAlignment = .center
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64.0),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64.0),
            nameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16.0)
        ])
    }
    
    func configureImageView() -> Void {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = KaleidoscopeResources.Images.MainScreen.ipad
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -64.0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64.0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64.0),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 64.0)
        ])
    }
    
    @objc func start() -> Void {
        presenter?.startStream()
    }
    
    @objc func settings() -> Void {
        presenter?.presentSettings()
    }
}
 
