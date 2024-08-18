//
//  APISecretTableViewCell.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 08.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit

final class LabeledTableViewCellWithTextField: UITableViewCell {
    
    // Properties
    private let label: String
    private let isSecure: Bool
    private let maskedCorners: UIRectCorner
    private let keyboardType: UIKeyboardType
    
    // Elements
    private let textField: UITextField = UITextField()
    private let container: UIView = UIView()
    private let cellLabel: UILabel = UILabel()

    init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil, label: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false, maskedCorners: UIRectCorner = []) {
        self.label = label
        self.isSecure = isSecure
        self.maskedCorners = maskedCorners
        self.keyboardType = keyboardType
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureCellLabel()
        configureTextField()

    }
    
    func getValue() -> String? {
        textField.text
    }
    
    func updateLabel(with value: String?) -> Void {
        textField.text = value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension LabeledTableViewCellWithTextField {
    
    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configureCorners() -> Void {
        let pathFrame: CGRect = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width - 32.0, height: bounds.height)
        let maskPath = UIBezierPath(roundedRect: pathFrame,
                                    byRoundingCorners: maskedCorners,
                                    cornerRadii: CGSize(width: 12.0, height: 12.0))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = pathFrame
        maskLayer.path = maskPath.cgPath
        
            
        container.layer.mask = maskLayer
    }
    
    func configureContainer() -> Void {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCellLabel() -> Void {
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.text = label
        cellLabel.textColor = .black
        cellLabel.font = .systemFont(ofSize: 17.0)
        cellLabel.numberOfLines = 1
        
        cellLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        cellLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        container.addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            cellLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    func configureTextField() -> Void {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter \(label)"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .none
        textField.isSecureTextEntry = isSecure
        textField.textAlignment = .right
        textField.tintColor = .mainTint
        textField.keyboardType = keyboardType
        
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        container.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: cellLabel.trailingAnchor, constant: 12.0),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            textField.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.0),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.0)
        ])
    }
}
