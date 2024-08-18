//
//  SettingsView.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 07.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit


final class SettingsView: UIView {
    
    // Elements
    private let titleLabel: UILabel = UILabel()
    private let doneButton: UIButton = UIButton(type: .system)
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    private let apiKeyCell: LabeledTableViewCellWithTextField = LabeledTableViewCellWithTextField(label: "API Key", maskedCorners: [.topLeft, .topRight])
    private let secretKeyCell: LabeledTableViewCellWithTextField = LabeledTableViewCellWithTextField(label: "Secret Key", maskedCorners: [.bottomLeft, .bottomRight])
    private let promptCell: LabeledTableViewCellWithTextView = LabeledTableViewCellWithTextView(label: "Prompt", maskedCorners: [.topLeft, .topRight])
    private let negativePromptCell: LabeledTableViewCellWithTextField = LabeledTableViewCellWithTextField(label: "Negative Prompt")
    private let stylesCell: LabeledTableViewCellWithPickerView = LabeledTableViewCellWithPickerView(label: "Styles")
    private let intervalCell: LabeledTableViewCellWithTextField = LabeledTableViewCellWithTextField(label: "Update Interval", keyboardType: .numberPad, isSecure: false, maskedCorners: [.bottomLeft, .bottomRight])

    weak var presenter: SettingsViewControllerPresenter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureDoneButton()
        configureTitleLabel()
        configureTableView()
    }
    
    func updateView(with configuration: SettingsConfiguration) {
        apiKeyCell.updateLabel(with: configuration.state.apiKey)
        secretKeyCell.updateLabel(with: configuration.state.secretKey)
        promptCell.updateValue(with: configuration.state.prompt)
        negativePromptCell.updateLabel(with: configuration.state.negativePrompt)
        stylesCell.updatePickerView(with: configuration.state.style)
        intervalCell.updateLabel(with: "\(configuration.state.interval)")
    }
    
    func updatePickerView(with styles: [KandinskyStyles]) -> Void {
        stylesCell.updatePickerView(with: styles)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension SettingsView {
    
    func configure() -> Void {
        backgroundColor = .white
    }
    
    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.text = "Settings"
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0)
        ])
    }
    
    func configureDoneButton() -> Void {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        doneButton.tintColor = .mainTint
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            doneButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.0)
        ])
    }
    
    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLineEtched
        tableView.delaysContentTouches = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 8.0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
        ])
    }
    
    var newConfiguratiuon: SettingsConfiguration {
        let configuration: SettingsConfiguration = SettingsConfiguration()
        
        configuration.setApiKey(apiKeyCell.getValue())
        configuration.setSecretKey(secretKeyCell.getValue())
        configuration.updatePrompt(promptCell.getValue())
        configuration.updateNegativePrompt(negativePromptCell.getValue())
        configuration.setStyle(stylesCell.getValue())
        configuration.updateInterval(intervalCell.getValue())
        
        return configuration
    }
    
    @objc func doneButtonAction() -> Void {
        presenter?.dismissAndUpdateConfiguration(newConfiguratiuon)
    }
}


extension SettingsView: UITableViewDelegate {}


extension SettingsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        default:
            fatalError("Need to add numberOfRowsInSection for section: \(section)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 0: return apiKeyCell
            case 1: return secretKeyCell
            default: fatalError("Unknown cell for API section.")
            }
        case 1:
            switch indexPath.row {
            case 0: return promptCell
            case 1: return negativePromptCell
            case 2: return stylesCell
            case 3: return intervalCell
            default: fatalError("Unknown cell for QUERY section.")
            }
        default:
            fatalError("Need to specify cell for section: \(indexPath.section)")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "    API"
        case 1:
            return "    Query"
        default:
            fatalError("Need to add titleForHeaderInSection for section: \(section)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                return 104.0
            case 2:
                return 104.0
            default: return 52.0
            }
        default: return 52.0
        }
    }
}
