//
//  LabeledTableViewCellWithPickerView.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 08.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit

final class LabeledTableViewCellWithPickerView: UITableViewCell {
    
    // Properties
    private let label: String
    private let maskedCorners: UIRectCorner
    private var selectedStyleName: String?
    
    private var pickerElements: [KandinskyStyles] = []
    
    // Elements
    private let container: UIView = UIView()
    private let cellLabel: UILabel = UILabel()
    private let picker: UIPickerView = UIPickerView()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil, label: String, maskedCorners: UIRectCorner = []) {
        self.label = label
        self.maskedCorners = maskedCorners
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureCellLabel()
        configurePickerView()
        configureIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCorners()
    }
    
    func getValue() -> KandinskyStyles? {
        guard !pickerElements.isEmpty else { return nil }
        return pickerElements[picker.selectedRow(inComponent: 0)]
    }
    
    func updatePickerView(with configurationStyle: String?) -> Void {
        guard let configurationStyle = configurationStyle else { return }
        
        self.selectedStyleName = configurationStyle
        
        guard !pickerElements.isEmpty, let row: Int = pickerElements.firstIndex(where: { $0.name == configurationStyle }) else { return }
    
        picker.selectRow(row, inComponent: 0, animated: true)
    }
    
    func updatePickerView(with styles: [KandinskyStyles]) -> Void {
        pickerElements = styles
        
        activityIndicator.stopAnimating()
        picker.reloadAllComponents()
        
        guard let selectedStyleName = selectedStyleName, let row: Int = pickerElements.firstIndex(where: { $0.name == selectedStyleName }) else { return }
        picker.selectRow(row, inComponent: 0, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension LabeledTableViewCellWithPickerView {
    
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
    
    func configureIndicator() -> Void {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        picker.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: picker.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: picker.centerXAnchor)
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
            cellLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.0)
        ])
    }
    
    func configurePickerView() -> Void {
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.dataSource = self
        picker.delegate = self
        
        container.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            picker.widthAnchor.constraint(equalToConstant: 170.0),
            picker.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            picker.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.0),
            picker.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.0),
        ])
    }
}


extension LabeledTableViewCellWithPickerView: UIPickerViewDelegate {
    
}

extension LabeledTableViewCellWithPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerElements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerElements[row].name
    }
}
