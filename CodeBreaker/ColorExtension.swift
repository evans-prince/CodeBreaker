//
//  SwiftUIView.swift
//  CodeBreaker
//
//  Created by PRINCE  on 2/16/26.
//

import SwiftUI

extension Color {
    // This is a "failable initializer" (init?).
    // It returns nil if the name doesn't match a color.
    init?(fromName name: String) {
        switch name.lowercased() {
            // Standard Colors
        case "red": self = .red
        case "green": self = .green
        case "blue": self = .blue
        case "yellow": self = .yellow
        case "orange": self = .orange
        case "black": self = .black
        case "white": self = .white
        case "brown": self = .brown
        case "pink": self = .pink
        case "cyan": self = .cyan
        case "gray": self = .gray
        case "purple": self = .purple
        case "mint": self = .mint
        case "teal": self = .teal
        case "indigo": self = .indigo
        case "clear": self = .clear
            
            // Earth Tones (Custom Colors)
        case "rust": self = Color(red: 0.72, green: 0.33, blue: 0.0)
        case "olive": self = Color(red: 0.5, green: 0.5, blue: 0.0)
        case "beige": self = Color(red: 0.96, green: 0.96, blue: 0.86)
        case "forest": self = Color(red: 0.13, green: 0.55, blue: 0.13)
        case "slate": self = Color(red: 0.44, green: 0.5, blue: 0.56)
        case "charcoal": self = Color(red: 0.21, green: 0.27, blue: 0.31)
        case "gold": self = Color(red: 1.0, green: 0.84, blue: 0.0)
        case "coffee": self = Color(red: 0.44, green: 0.30, blue: 0.22)
        case "sand": self = Color(red: 0.76, green: 0.70, blue: 0.50)
        case "clay": self = Color(red: 0.80, green: 0.52, blue: 0.25)
            
        default: return nil
        }
    }
    
    var name: String? {
        if self == .red { return "red" }
        if self == .green { return "green" }
        if self == .blue { return "blue" }
        if self == .yellow { return "yellow" }
        if self == .orange { return "orange" }
        if self == .brown { return "brown" }
        if self == .black { return "black" }
        if self == .white { return "white" }
        if self == .purple { return "purple" }
        if self == .pink { return "pink" }
        if self == .cyan { return "cyan" }
        if self == .gray { return "gray" }
        if self == .clear { return "clear" }
        
        // If it's none of the above (or a custom color), return nil
        return nil
    }
}
