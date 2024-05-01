//
//  Typography.swift
//  Storybox
//
//  Created by User on 24.04.24.
//

import SwiftUI

extension Font {
    public static func golosUI(size: CGFloat) -> Font {
        return Font.custom("GolosUI-VF", size: size)
    }

    public static func literata(size: CGFloat) -> Font {
        return Font.custom("Literata36pt-Medium", size: size)
    }
    
    public static func golosUIRegular(size: CGFloat) -> Font {
        return Font.custom("GolosUI-Regular", size: size)
    }

    public static func golosUIBold(size: CGFloat) -> Font {
        return Font.custom("GolosUI-Bold", size: size)
    }
}

extension Text {
    func variableFont(name: String, size: CGFloat, weight: UIFont.Weight = .regular) -> some View {
        // Create a UIFont with the specific attributes
        let uiFont = UIFont(name: name, size: size)?.withWeight(weight) ?? UIFont.systemFont(ofSize: size)
        
        // Convert UIFont to SwiftUI's Font
        let font = Font(uiFont)
        return self.font(font)
    }
}

// Helper extension to manage font weights in UIFont
extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let traits = [UIFontDescriptor.TraitKey.weight: weight]
        var attributes = fontDescriptor.fontAttributes
        attributes[UIFontDescriptor.AttributeName.traits] = traits
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}


