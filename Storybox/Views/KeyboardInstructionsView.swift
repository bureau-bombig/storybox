//
//  KeyboardInstructionsView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

struct KeyboardInstructionsView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack(spacing: 20) {
            Text("Keyboard Operating Instructions")
                .font(.golosUI(size: 42))
                .foregroundColor(.white)
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                InstructionView(
                    image: "keyboard",
                    text: "Use the arrow keys to navigate through the app."
                )
                InstructionView(
                    image: "return",
                    text: "Press the Enter key to select or confirm actions."
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            Button("Alright") {
                appState.currentView = .userDataInput
            }
            .font(.golosUI(size: 18))
            .foregroundColor(.white)
            .padding()
            .background(Color.AppPrimaryDark)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.AppSecondary, lineWidth: 2)
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppPrimary)
        .edgesIgnoringSafeArea(.all)
    }
}

struct InstructionView: View {
    let image: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)

            Text(text)
                .font(.literata(size: 16))
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity)
    }
}

		
#Preview {
    KeyboardInstructionsView()
}
