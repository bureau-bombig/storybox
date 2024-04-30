//
//  ThankYouView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI


struct ThankYouView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("Thank You!")
                        .font(.golosUI(size: 42))
                        .foregroundColor(.white)
                        .padding()

                    Text("Your contribution is highly valuable to our project. Feel free to share more thoughts!")
                        .font(.literata(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button("Press space bar to start new") {
                        self.nextAction()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.AppSecondary)
                    .cornerRadius(10)
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.AppPrimary)
                .cornerRadius(10)

                Spacer()
            }
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
            .background(KeyboardResponder(nextAction: self.nextAction).frame(width: 0, height: 0, alignment: .center))
        }
    }
    
    private func nextAction() {
        appState.currentView = .welcome
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
    ThankYouView()
}
