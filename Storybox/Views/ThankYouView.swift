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
        ZStack {
            Image("welcome-background") // Ensure this image is in your asset catalog
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                Spacer()
                VStack(alignment: .center) {
                    
                        Text("Vielen Dank für")
                            .font(.golosUIBold(size: 65))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.60, alignment: .center)
                            
                        Text("deinen Beitrag")
                            .font(.literata(size: 65))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.60, alignment: .center)
                            .padding(.bottom, 20)
                        
                        Text("Du findest deine Beiträge nach ein paar Tagen im Freiheitsarchiv.")
                            .font(.golosUIRegular(size: 26))
                            .lineSpacing(12)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width, alignment: .center)
                            .padding(.bottom, 20)
                    
                    Text("www․freiheitsarchiv․de")
                        .font(.golosUIBold(size: 32))
                        .lineSpacing(12)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                }
                Spacer()
                Image("qr-code")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                Spacer()
                HStack {
                    VStack {
                        Image("Spacebar")
                            .padding(20)
                        
                        Button("Leertaste zum Abschließen") {
                            self.nextAction()
                        }
                         .font(.golosUIRegular(size: 26))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(KeyboardResponder(nextAction: self.nextAction).frame(width: 0, height: 0, alignment: .center))
    }
    
    private func nextAction() {
        AppManager.shared.restartApplication()
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
            AppManager.shared.resetIdleTimer() 
            
            if (key.keyCode.rawValue == 44) {
                nextAction?()

            }
            if key.keyCode.rawValue == 69 {
                AppManager.shared.restartApplication()
            }
        }
    }
}

#Preview {
    ThankYouView()
}
