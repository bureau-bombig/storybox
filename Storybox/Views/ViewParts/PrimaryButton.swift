//
//  PrimaryButton.swift
//  Storybox
//
//  Created by User on 01.05.24.
//

import SwiftUI

extension Button {
    func styledButton(textColor: Color = .AppPrimary, backgroundColor: Color = .white, focused: Bool = false, outline: Bool = false) -> some View {
        self.font(.golosUIBold(size: 20))
            .foregroundColor(outline ? .white : textColor)
            .padding(.horizontal, 60)
            .padding(.vertical, 20)
            .background(outline ? Color.clear : backgroundColor)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        focused ? Color.AppSecondary : (outline ? Color.white : Color.AppPrimaryDark),
                        lineWidth: focused ? 10 : 2
                    )
            )
    }
}
