//
//  KaleidoscopeCustomButton.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 07.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit


extension KaleidoscopeCustomButton {
    enum KaleidoscopeButtonStyle {
        case plain
        case outlined
    }
}


final class KaleidoscopeCustomButton: UIButton {

    // Properties
    private var title: String!
    private var action: Selector!
    private var style: KaleidoscopeButtonStyle!

    convenience init(
        style: KaleidoscopeButtonStyle,
        title: String,
        action: Selector,
        type: UIButton.ButtonType = .system
    ) {
        self.init(type: type)
        
        self.style = style
        self.title = title
        self.action = action
        
        configure()
    }

}


private extension KaleidoscopeCustomButton {
    
    func configure() -> Void {
        switch style {
        case .outlined:
            configureOutlinedButton()
        case .plain:
            configurePlainButton()
        default:
            fatalError("Unknown style.")
        }
    }

    func configurePlainButton() -> Void {
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(UIColor.mainTint.darkened(), for: .highlighted)
        setBackgroundImage(.solidFill(with: .mainTint), for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17.0, weight: .medium)
        titleLabel?.textColor = .white
        tintColor = .white
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addTarget(nil, action: action, for: .touchUpInside)
    }
    
    func configureOutlinedButton() -> Void {
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(.mainTint, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17.0, weight: .medium)
        tintColor = .mainTint
        layer.borderWidth = 2
        layer.borderColor = UIColor.mainTint.cgColor
        layer.cornerRadius = 12.0
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true

        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)

        addTarget(nil, action: action, for: .touchUpInside)

        }

        @objc func touchDown() {
            animateBorderColor(to: UIColor.highlightedMainTint.cgColor, duration: 0.01)
        }

        @objc func touchUpInside() {
            animateBorderColor(to: UIColor.mainTint.cgColor, duration: 0.1)
        }

        @objc func touchUpOutside() {
            animateBorderColor(to: UIColor.mainTint.cgColor, duration: 0.1)
        }

        @objc func touchDragExit() {
            animateBorderColor(to: UIColor.mainTint.cgColor, duration: 0.1)
        }

        func animateBorderColor(to color: CGColor, duration: CFTimeInterval) {
            let animation = CABasicAnimation(keyPath: "borderColor")
            animation.fromValue = self.layer.borderColor
            animation.toValue = color
            animation.duration = duration
            
            layer.add(animation, forKey: "borderColor")
            layer.borderColor = color
        }
}
