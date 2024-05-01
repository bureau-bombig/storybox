//
//  UserDataInputView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

struct UserDataInputView: View {
    @EnvironmentObject var appState: AppState
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var realName: String = ""
    @State private var locality: String = ""
    @State private var termsAccepted: Bool = false
    @State private var focusedIndex: Int = 0
    

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer();
                    Text("User Data Input")
                        .font(.golosUIRegular(size: 42))
                        .foregroundColor(.white)
                        .padding(.top, 40)

                    Text("Please fill in your details to continue. Your information helps us understand who's engaging with our project.")
                        .font(.literata(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()

                    VStack(spacing: 15) {
                        LabelledTextField(label: "Nickname", placeholder: "Enter your nickname", text: $nickname)
                        LabelledTextField(label: "Email", placeholder: "Enter your email", text: $email)
                        LabelledTextField(label: "Real Name", placeholder: "Enter your real name", text: $realName)
                        LabelledTextField(label: "Locality", placeholder: "Enter your locality", text: $locality)
                        
                        Toggle(isOn: $termsAccepted) {
                            Text("I accept the terms and conditions")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: 500)
                    }
                    .padding()

                    HStack {
                        Button("Back") {
                            self.backAction()
                        }
                        .styledButton(textColor:Color.AppPrimaryDark , backgroundColor: .white, focused: focusedIndex == 0)

                        Button("Confirm") {
                            self.nextAction()
                        }
                        .styledButton(textColor: Color.AppPrimaryDark, backgroundColor: .white, focused: focusedIndex == 1)
                    }
                    .padding(.bottom, 40)
                    
                    Spacer();
                }
                .frame(minWidth: geometry.size.width)
            }
            .frame(width: geometry.size.width)
        }
        .background(Color.AppPrimary)
        .edgesIgnoringSafeArea(.all)
        .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [self.backAction, self.nextAction]).frame(width: 0, height: 0, alignment: .center))
    }
    
    private func nextAction() {
        appState.currentView = .chooseTopic
    }
    
    private func backAction() {
        appState.currentView = .keyboardInstructions
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


struct LabelledTextField: View {
    var label: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.literata(size: 18))
                .foregroundColor(.white)
            CustomTextField(placeholder: placeholder, text: $text)
                .frame(height: 44)
                .padding(.horizontal)
                .frame(width: 500)
        }
    }
}

struct CustomTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String

    func makeUIView(context: Context) -> NoAccessoryTextField {
        let textField = NoAccessoryTextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        return textField
    }

    func updateUIView(_ uiView: NoAccessoryTextField, context: Context) {
        uiView.text = text
    }
}


#Preview {
    UserDataInputView()
}
