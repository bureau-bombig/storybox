//
//  WelcomeView.swift
//  Storybox
//
//  Created by User on 24.04.24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Image("welcome-background") // Ensure this image is in your asset catalog
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
             
            
            VStack() {
                HStack {
                    VStack(alignment: .leading) {
                        
                            Text("Willkommen in der Erzählbox des")
                                .font(.golosUIBold(size: 65))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.60, alignment: .leading)
                                
                            Text("Freiheitsarchiv")
                                .font(.literata(size: 65))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.60, alignment: .leading)
                                .padding(.bottom, 20)
                            
                            Text("Ein Projekt der Universität Hamburg und freien Künstler:innen und Theatermacher:innen")
                                .font(.golosUIRegular(size: 26))
                                .lineSpacing(12)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .frame(width: UIScreen.main.bounds.width * 0.40, alignment: .leading)
                                .lineSpacing(8)
                    }

                
                    // Badge on the right side
                    VStack {
                        HStack {
                            Image(systemName: "globe")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.AppSecondary)
                                .frame(width: 64, height: 64)
                                .padding(.trailing, 16)
                            Text("Answer in any language you prefer!")
                                .font(.golosUIBold(size: 26))
                                .foregroundColor(.white)
                        }
                        .padding(.all, 16)
                        .background(Color.AppPrimary.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                        )
                        .onTapGesture(count: 5) {
                            self.showAdminSettings()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .padding(.leading, 60)

                Spacer()
                
                HStack {
                    VStack {
                        Image("Spacebar")
                            .padding(20)
                        
                        Button("Leertaste zum Starten") {
                            self.nextAction()
                        }
                         .font(.golosUIRegular(size: 26))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 60)
                }
                
            }
        }
        .background(KeyboardResponder(nextAction: self.nextAction).frame(width: 0, height: 0, alignment: .center))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Fehler in den Administrationseinstellungen"),
                message: Text("Bitte einem Administrator bescheid geben"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func nextAction() {
        // Check if any provenance is selected and at least one topic is checked
        if let _ = AdminSettingsManager.shared.getSelectedProvenanceID(),
           !AdminSettingsManager.shared.getSelectedTopicIDs().isEmpty {
            appState.currentView = .keyboardInstructions
        } else {
            showAlert = true // Show alert if conditions are not met
        }
    }
    
    private func showAdminSettings() {
        appState.currentView = .adminSettings
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
            
            if key.modifierFlags.intersection([.control, .shift, .alternate]).contains([.control, .shift, .alternate]) && key.charactersIgnoringModifiers == "q" {
                AppManager.shared.restartApplication()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
