//
//  KeyboardInstructionsView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

struct KeyboardInstructionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var focusedIndex: Int = 1

    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 0) {
            Text("So bedienst du die")
                .font(.golosUIBold(size: 45))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            Text("Erzählbox")
                .font(.literata(size: 45))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            }


            Spacer()
            
            HStack(spacing: 12) {
                InstructionView(
                    image: "arrowkeys",
                    text: "Pfeiltasten zum navigaieren"
                )
                InstructionView(
                    image: "Spacebar",
                    text: "Leertaste zum bestätigen"
                )
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(Color.AppPrimaryDark)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            
            Spacer()
            
            HStack () {
            Button("Zurück zum Start") {
                self.nextAction()
            }
            .styledButton(focused: focusedIndex == 0)
            
                Spacer()
                
            Button("Alles klar") {
                self.nextAction()
            }
            .styledButton(focused: focusedIndex == 1)
            }
        }
        .padding(100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppPrimary)
        .edgesIgnoringSafeArea(.all)
        .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [self.backAction, self.nextAction]).frame(width: 0, height: 0, alignment: .center))
    }
    
    private func nextAction() {
        appState.currentView = .userDataInput
    }

    private func backAction() {
        appState.currentView = .welcome
    }

    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int
        var actionHandlers: [() -> Void]

        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            let controller = KeyboardViewController()
            controller.focusedIndex = $focusedIndex
            controller.actionHandlers = actionHandlers
            return controller
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {}
    }
}

private class KeyboardViewController: UIViewController {
    var focusedIndex: Binding<Int>!
    var actionHandlers: [() -> Void]!
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    override func pressesBegan(_ presses: Set<UIPress>,
                               with event: UIPressesEvent?) {
        
        for press in presses {
            guard let key = press.key else { continue }
            print("Key pressed: \(key)")
            
            switch key.keyCode.rawValue {
            case (80): // left arrow key
                if focusedIndex.wrappedValue > 0 {
                    focusedIndex.wrappedValue -= 1
                }
            case (79): // right arrow key
                if focusedIndex.wrappedValue < actionHandlers.count - 1 {
                    focusedIndex.wrappedValue += 1
                }
            case (44): // space bar
                actionHandlers[focusedIndex.wrappedValue]()
            default:
                break
            }
        }
    }
}

struct InstructionView: View {
    let image: String
    let text: String

    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)

            Text(text)
                .font(.golosUIBold(size: 26))
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity)
    }
}

		
#Preview {
    KeyboardInstructionsView()
}
