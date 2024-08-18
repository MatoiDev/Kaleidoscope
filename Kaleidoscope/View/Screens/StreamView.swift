//
//  StreamView.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 10.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit

final class StreamView: UIView {
    
    // Properties
    private var headerViewTopConstraint: NSLayoutConstraint!
    
    // Elements
    private let backButton: UIButton = UIButton(type: .system)
    private let headerView: UIView = UIView()
    private let imageView: UIImageView = UIImageView()
    private let centralContainerView: UIStackView = UIStackView()
    private let loadingLabel: UILabel = UILabel()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    weak var presenter: StreamViewControllerPresenter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        configureIndicator()
        configureLoadingLabel()
        configureCentralContainerView()
        configureImageView()
        configureHeaderView()
        configureBackButton()
    }
    
    func updateView(with image: UIImage) -> Void {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 1.0) {
            self.imageView.image = image
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StreamView {
    
    func configure() -> Void {
        backgroundColor = .white
    }
    
    func configureCentralContainerView() -> Void {
        centralContainerView.translatesAutoresizingMaskIntoConstraints = false
        centralContainerView.backgroundColor = .clear
        centralContainerView.spacing = 8.0
        
        centralContainerView.addArrangedSubview(activityIndicator)
        centralContainerView.addArrangedSubview(loadingLabel)
        
        addSubview(centralContainerView)
        NSLayoutConstraint.activate([
            centralContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centralContainerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureLoadingLabel() -> Void {
        loadingLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
        loadingLabel.textColor = .black
        loadingLabel.text = "Generating first image..."
    }
    
    func configureIndicator() -> Void {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func configureImageView() -> Void {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHeaderView)))
        imageView.isUserInteractionEnabled = true
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureHeaderView() -> Void {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .black
        headerView.alpha = 0.5
        headerView.isHidden = true
        
        addSubview(headerView)
        headerViewTopConstraint = headerView.topAnchor.constraint(equalTo: topAnchor, constant: -100)
        headerViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 57.0)
        ])
    }
    
    func configureBackButton() -> Void {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Close", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtunAction), for: .touchUpInside)
        
        headerView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16.0),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12.0),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12.0)
        ])
    }
    
    @objc func backButtunAction() -> Void {
        self.headerView.isHidden = true
        presenter?.dismiss()
    }
    
    @objc func toggleHeaderView() -> Void {
        let headerHeight: CGFloat = 57.0
        self.headerView.isHidden = false
        if headerViewTopConstraint.constant < 0 {
            headerViewTopConstraint.constant = 0
        } else {
            headerViewTopConstraint.constant = -headerHeight
        }
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
}



