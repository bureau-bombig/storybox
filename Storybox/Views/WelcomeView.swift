//
//  WelcomeView.swift
//  Storybox
//
//  Created by User on 24.04.24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Storybox")
                .font(.golosUI(size: 42))
                .foregroundColor(.white)  // Set text color to white
            
            Text("Explore the power of storytelling and share your unique perspectives.")
                .font(.golosUI(size: 16))
                .foregroundColor(.white)  // Set text color to white
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                self.nextAction()
            }) {
                Text("Press space to Start")
                    .font(.golosUI(size: 18))
                    .foregroundColor(.white)  // Set button text color to white
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
                    .background(Color.AppPrimaryDark)  // Use PrimaryDark for button background
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.AppSecondary, lineWidth: 2)
                    )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppPrimary)  // Use Primary color for background
        .edgesIgnoringSafeArea(.all)
        .background(KeyboardResponder(nextAction: self.nextAction).frame(width: 0, height: 0, alignment: .center))
    }
    
    private func nextAction() {
        appState.currentView = .keyboardInstructions
    }

    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        var nextAction: () -> Void
        
        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            let controller = KeyboardViewController()
            controller.nextAction = nextAction
            return controller
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {
            // Update logic if necessary
        }
    }
}

private class KeyboardViewController: UIViewController {
    var nextAction: (() -> Void)?
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    override func pressesBegan(_ presses: Set<UIPress>,
                               with event: UIPressesEvent?) {
        
        for press in presses {
            guard let key = press.key else { continue }
            print("Key pressed: \(key)")
            
            if (key.keyCode.rawValue == 44) {
                nextAction?()

            }
        }
    }
}

#Preview {
    WelcomeView()
}
