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
                    text: "Press the space bar to select or confirm actions."
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            Button("Alright") {
                self.nextAction()
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
        .background(KeyboardResponder(nextAction: self.nextAction).frame(width: 0, height: 0, alignment: .center))
    }
    
    private func nextAction() {
        appState.currentView = .userDataInput
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
