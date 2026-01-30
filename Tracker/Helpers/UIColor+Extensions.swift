//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).trimmingPrefix(while: {$0 == "#"}).uppercased()
        var rgbInt: Int = 0
        Scanner(string: hex).scanInt(&rgbInt)
        self.init(rgb: rgbInt, alpha: 1.0)
    }
    
    func toString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alphaCanal: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alphaCanal)
        
        let result = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255)
        return String(format: "#%06X", result)
    }
}
