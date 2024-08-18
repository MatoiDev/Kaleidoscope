//
//  UIImage+Extensions.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 07.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//


import UIKit


extension UIImage {
    
    static func solidFill(with color: UIColor) -> UIImage {
        let image: UIImage = Self.generatePixel(ofColor: color)
        return image
    }
    
    static private func generatePixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(pixel.size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.setFillColor(color.cgColor)
        context.fill(pixel)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
