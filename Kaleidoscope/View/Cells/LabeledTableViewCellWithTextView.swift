//
//  LabeledTableViewCellWithTextView.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 08.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit


final class LabeledTableViewCellWithTextView: UITableViewCell {
    
    // Properties
    private let label: String
    private let maskedCorners: UIRectCorner
    
    // Elements
    let textView: UITextView = UITextView()
    private let container: UIView = UIView()
    private let cellLabel: UILabel = UILabel()

    init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil, label: String, maskedCorners: UIRectCorner = []) {
        self.label = label
        self.maskedCorners = maskedCorners
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCorners()
    }
    
    func getValue() -> String? {
        textView.text
    }
    
    func updateValue(with value: String?) -> Void {
        guard let value = value, value != "Enter \(label)", !value.isEmpty, !value.components(separatedBy: " ").joined(separator: "").isEmpty else {
            textView.text = "Enter \(label)"
            textView.textColor = .lightGray
            return
        }
        
        textView.text = value
        textView.textColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension LabeledTableViewCellWithTextView {
    
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
    
    func configureTextView() -> Void {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 17.0)
        textView.tintColor = .mainTint
        textView.text = "Enter \(label)"
        textView.textColor = .lightGray
        
        textView.delegate = self
        
        container.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.0),
            textView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.0),
            textView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0.0),
            textView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -0.0)
        ])
    }
}


extension LabeledTableViewCellWithTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter \(label)"
            textView.textColor = .lightGray
        }
    }
}
