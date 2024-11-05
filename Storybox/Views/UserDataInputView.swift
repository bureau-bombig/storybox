//
//  UserDataInputView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import UIKit

struct UserDataInputView: View {
    @EnvironmentObject var appState: AppState
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var realName: String = ""
    @State private var locality: String = ""
    @State private var focusedIndex: Int = 0
    @State private var nicknameTouched: Bool = false
    @State private var emailTouched: Bool = false
    @State private var realNameTouched: Bool = false
    @State private var localityTouched: Bool = false
    @State private var showingLegalDocuments = false
    @State private var selectedDocumentType: String = "gdpr" // Default document type


    

    var body: some View {
                VStack(spacing: 20) {
                    HStack (spacing: 40) {
                    VStack(alignment: .leading, spacing: 0) {
                    Text("Nur kurz bevor")
                        .font(.golosUIBold(size: 45))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Text("es losgeht")
                        .font(.literata(size: 45))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    }
                     
                        Spacer()
                        
                        
                        Text("Wir brauchen nur ein paar Angaben zu deiner Person, deine Zustimmung zu unseren Bestimmungen und dann kann es schon losgehen!")
                            .font(.golosUIRegular(size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .lineSpacing(8)
                        
                    }

                    Spacer()


                    VStack(alignment: .leading, spacing: 40) {
                        
                        HStack (spacing: 60){
                            LabelledTextField(label: "Pseudonym (Öffentlich)", placeholder: "Wie willst du dich nennen?", text: $nickname, isFocused: Binding(
                                get: { self.focusedIndex == 0 },
                                set: { if $0 { self.focusedIndex = 0 } }
                            ), isTouched: $nicknameTouched, isValid: !nickname.isEmpty)
                            LabelledTextField(label: "E-Mail-Adresse (Nicht öffentlich sichtbar)", placeholder: "Deine E-Mail-Adresse", text: $email, isFocused: Binding(
                                get: { self.focusedIndex == 1 },
                                set: { if $0 { self.focusedIndex = 1 } }
                            ), isTouched: $emailTouched,  isValid: email.isValidEmail())
                        }
                        HStack (spacing: 60){
                            LabelledTextField(label: "Dein Vor- und Nachname (Nicht öffentlich sichtbar)", placeholder: "Wie heißt du wirklich?", text: $realName, isFocused: Binding(
                                get: { self.focusedIndex == 2 },
                                set: { if $0 { self.focusedIndex = 2 } }
                            ), isTouched: $realNameTouched,  isValid: !realName.isEmpty)
                            LabelledTextField(label: "Wohnort (Nicht öffentlich sichtbar)", placeholder: "In welcher Stadt lebst du?", text: $locality, isFocused: Binding(
                                get: { self.focusedIndex == 3 },
                                set: { if $0 { self.focusedIndex = 3 } }
                            ), isTouched: $localityTouched,  isValid: !locality.isEmpty)
                        }
 
                        VStack(alignment: .leading, spacing: 4) {
                 
                            HStack {
                                Text("Ich habe die")
                                    .font(.golosUIRegular(size: 20))
                                    .foregroundColor(.white)
                                
                                FocusableText(text: "Datenschutzerklärung", index: 4, focusedIndex: $focusedIndex)
                                Text(",")
                                    .font(.golosUIRegular(size: 20))
                                    .foregroundColor(.white)

                                Text("die")
                                    .font(.golosUIRegular(size: 20))
                                    .foregroundColor(.white)
                                
                                FocusableText(text: "Einwilligungserklärung", index: 5, focusedIndex: $focusedIndex)
                                Text("zur Verarbeitung meiner")
                                    .font(.golosUIRegular(size: 20))
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("personenbezogenen Daten und")
                                    .font(.golosUIRegular(size: 20))
                                    .foregroundColor(.white)
                                FocusableText(text: "Einreichbedingungen", index: 6, focusedIndex: $focusedIndex)
                                Text("vollständig gelesen und stimme diesen zu.")
                                    .font(.golosUIRegular(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure it aligns to the left and wraps text



                    }

                    Spacer()
                    
                    HStack {
                        Button("Zurück") {
                            self.backAction()
                        }
                        .styledButton(focused: focusedIndex == 7, outline: true)
                        
                        Spacer()

                        Button("Bestätigen") {
                                self.nextAction()
                        }
                        .styledButton(focused: focusedIndex == 8)
                        .disabled(!validateInputs())
                    }
        }
        .padding(60)
        .background(Color.AppPrimary)
        .edgesIgnoringSafeArea(.all)
        .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [self.backAction, self.nextAction], textInputs: [$nickname, $email, $realName, $locality], selectedDocumentType: $selectedDocumentType, showingLegalDocuments: $showingLegalDocuments))
        .overlay(
                   showingLegalDocuments ? LegalDocumentsView(selectedDocument: $selectedDocumentType).onTapGesture {
                       showingLegalDocuments = false
                   } : nil
               )
    }
    
    struct FocusableText: View {
        let text: String
        let index: Int
        @Binding var focusedIndex: Int

        var body: some View {
            Text(text)
                .font(.golosUIRegular(size: 20))
                .foregroundColor(focusedIndex == index ? Color("AppSecondary") : .white)
                .padding(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(focusedIndex == index ? Color("AppSecondary") : Color.clear, lineWidth: 2)
                )
                .onTapGesture {
                    focusedIndex = index  // This will toggle focus on and off by clicking the same item again
                }
        }
    }

    
    private func nextAction() {
        if validateInputs() {
            appState.nickname = nickname
            appState.email = email
            appState.realName = realName
            appState.locality = locality
            self.appState.currentView = .chooseTopic
        } else {
            print("not valid")
            nicknameTouched = true
            emailTouched = true
            realNameTouched = true
            localityTouched = true
        }
    }

    private func backAction() {
            self.appState.currentView = .keyboardInstructions
    }

    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int
        var actionHandlers: [() -> Void]
        var textInputs: [Binding<String>]
        @Binding var selectedDocumentType: String
        @Binding var showingLegalDocuments: Bool

        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            return KeyboardViewController(focusedIndex: $focusedIndex, textInputs: textInputs, actionHandlers: actionHandlers, selectedDocumentType: $selectedDocumentType, showingLegalDocuments: $showingLegalDocuments)
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {
            // Update properties as needed
            uiViewController.focusedIndex = $focusedIndex
            uiViewController.actionHandlers = actionHandlers
        }
    }
    
    private func validateInputs() -> Bool {
        return !nickname.isEmpty &&
               email.isValidEmail() &&
               !realName.isEmpty &&
               !locality.isEmpty
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

private class KeyboardViewController: UIViewController {
    var focusedIndex: Binding<Int>
    var selectedDocumentType: Binding<String>
    var showingLegalDocuments: Binding<Bool>
    var textInputs: [Binding<String>]
    var actionHandlers: [() -> Void]
    private var deleteTimer: Timer?
    var shouldResignFirstResponder = false

    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldResignFirstResponder = true
        DispatchQueue.main.async {
            _ = self.resignFirstResponder()
        }
    }

    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        if shouldResignFirstResponder {
            super.resignFirstResponder()
            return true
        }
        return false
    }

    init(focusedIndex: Binding<Int>, textInputs: [Binding<String>], actionHandlers: [() -> Void], selectedDocumentType: Binding<String>, showingLegalDocuments: Binding<Bool>) {
        self.focusedIndex = focusedIndex
        self.textInputs = textInputs
        self.actionHandlers = actionHandlers
        self.selectedDocumentType = selectedDocumentType
        self.showingLegalDocuments = showingLegalDocuments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Handling the key presses
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else {
             return // Exit if no key is found.
         }

        print("Key pressed: \(key.keyCode)")
        AppManager.shared.resetIdleTimer() 

        switch key.keyCode.rawValue {
        case (80):
            if !showingLegalDocuments.wrappedValue && focusedIndex.wrappedValue > 0 {
                focusedIndex.wrappedValue -= 1
            } else {
                playErrorSound()
            }
        case (79):
            if !showingLegalDocuments.wrappedValue && focusedIndex.wrappedValue < 8 { // Includes navigation to buttons
                focusedIndex.wrappedValue += 1
            } else {
                playErrorSound()
            }
        case (82):
            if !showingLegalDocuments.wrappedValue && focusedIndex.wrappedValue > 1 {
                focusedIndex.wrappedValue -= 2
            } else if (!showingLegalDocuments.wrappedValue) {
                playErrorSound()
            }
            if showingLegalDocuments.wrappedValue {
                // Logic to scroll up in the web view
                NotificationCenter.default.post(name: Notification.Name("ScrollUpLegalDocument"), object: nil)
            }
        case (81):
            if !showingLegalDocuments.wrappedValue && focusedIndex.wrappedValue < 7 {
                focusedIndex.wrappedValue += 2
            } else if (!showingLegalDocuments.wrappedValue) {
                playErrorSound()
            }
            if showingLegalDocuments.wrappedValue {
                // Logic to scroll down in the web view
                NotificationCenter.default.post(name: Notification.Name("ScrollDownLegalDocument"), object: nil)
            }
        case (43):
            if !showingLegalDocuments.wrappedValue && focusedIndex.wrappedValue < 8 {
                focusedIndex.wrappedValue += 1
            }
        case 44, 40: // Space key
            if focusedIndex.wrappedValue < 4 { // Assuming indexes 0-3 are for text fields
                appendText(" ")
            } else {
                switch focusedIndex.wrappedValue {
                case 4, 5, 6: // Assuming these are your focusable legal document links
                    showingLegalDocuments.wrappedValue.toggle() // Correct way to toggle
                    if showingLegalDocuments.wrappedValue { // Check the actual value
                        switch focusedIndex.wrappedValue {
                        case 4:
                            selectedDocumentType.wrappedValue = "gdpr"
                        case 5:
                            selectedDocumentType.wrappedValue = "consent"
                        case 6:
                            selectedDocumentType.wrappedValue = "condition"
                        default:
                            break
                        }
                    }
                default:
                    // Handle other buttons or actions
                    if (focusedIndex.wrappedValue == 7) {
                        actionHandlers[0]()
                    }
                    if (focusedIndex.wrappedValue == 8) {
                        actionHandlers[1]()
                    }
                }
            }
        case (42):
            handleDeleteKeyPress()
            if deleteTimer == nil {
                startDeleting()
            }
        case (69):
            AppManager.shared.restartApplication()
        default:
            if let character = mapKeyToCharacter(key: key) {
                appendText(character)
            }
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        for press in presses {
            if press.key?.keyCode == .keyboardDeleteOrBackspace {
                stopDeleting()
            }
        }
    }
    
    private func startDeleting() {
        deleteTimer?.invalidate() // Ensure only one timer is running
        deleteTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.deleteBackward()
        }
    }
    
    private func handleDeleteKeyPress() {
        deleteBackward()
    }

    private func stopDeleting() {
        deleteTimer?.invalidate()
        deleteTimer = nil
    }

    private func deleteBackward() {
        guard focusedIndex.wrappedValue < textInputs.count else { return }
        var text = textInputs[focusedIndex.wrappedValue].wrappedValue
        if !text.isEmpty {
            text.removeLast()
            textInputs[focusedIndex.wrappedValue].wrappedValue = text
        }
    }
    
    private func mapKeyToCharacter(key: UIKey) -> String? {
        let shiftPressed = key.modifierFlags.contains(.shift)
        let optionPressed = key.modifierFlags.contains(.alternate)

        switch key.keyCode {
            case .keyboardA: return shiftPressed ? "A" : "a"
            case .keyboardB: return shiftPressed ? "B" : "b"
            case .keyboardC: return shiftPressed ? "C" : "c"
            case .keyboardD: return shiftPressed ? "D" : "d"
            case .keyboardE: return shiftPressed ? "E" : "e"
            case .keyboardF: return shiftPressed ? "F" : "f"
            case .keyboardG: return shiftPressed ? "G" : "g"
            case .keyboardH: return shiftPressed ? "H" : "h"
            case .keyboardI: return shiftPressed ? "I" : "i"
            case .keyboardJ: return shiftPressed ? "J" : "j"
            case .keyboardK: return shiftPressed ? "K" : "k"
            case .keyboardL: return shiftPressed ? "L" : "l"
            case .keyboardM: return shiftPressed ? "M" : "m"
            case .keyboardN: return shiftPressed ? "N" : "n"
            case .keyboardO: return shiftPressed ? "O" : "o"
            case .keyboardP: return shiftPressed ? "P" : "p"
            case .keyboardQ:
                if optionPressed { return "@" }
                return shiftPressed ? "Q" : "q"
            case .keyboardR: return shiftPressed ? "R" : "r"
            case .keyboardS: return shiftPressed ? "S" : "s"
            case .keyboardT: return shiftPressed ? "T" : "t"
            case .keyboardU: return shiftPressed ? "U" : "u"
            case .keyboardV: return shiftPressed ? "V" : "v"
            case .keyboardW: return shiftPressed ? "W" : "w"
            case .keyboardX: return shiftPressed ? "X" : "x"
            case .keyboardY: return shiftPressed ? "Z" : "z"
            case .keyboardZ: return shiftPressed ? "Y" : "y"

            case .keyboard1: return shiftPressed ? "!" : "1"
            case .keyboard2: return shiftPressed ? "\"" : "2"
            case .keyboard3: return shiftPressed ? "§" : "3"
            case .keyboard4: return shiftPressed ? "$" : "4"
            case .keyboard5: return shiftPressed ? "%" : "5"
            case .keyboard6: return shiftPressed ? "&" : "6"
            case .keyboard7: return shiftPressed ? "/" : "7"
            case .keyboard8: return shiftPressed ? "(" : "8"
            case .keyboard9: return shiftPressed ? ")" : "9"
            case .keyboard0: return shiftPressed ? "=" : "0"

            case .keyboardHyphen: return shiftPressed ? "?" : "-"
            case .keyboardEqualSign: return shiftPressed ? "`" : "´"
            case .keyboardOpenBracket: return shiftPressed ? "Ü" : "ü"
            case .keyboardCloseBracket: return shiftPressed ? "+" : "*"
            case .keyboardBackslash: return shiftPressed ? "'" : "#"
            case .keyboardSemicolon: return shiftPressed ? "Ö" : "ö"
            case .keyboardQuote: return shiftPressed ? "Ä" : "ä"
            case .keyboardComma: return shiftPressed ? ";" : ","
            case .keyboardPeriod: return shiftPressed ? ":" : "."
            case .keyboardSlash: return shiftPressed ? "_" : "-"

            default:
                return nil
            }
    }

    private func appendText(_ text: String) {
        guard focusedIndex.wrappedValue < textInputs.count else { return }
        textInputs[focusedIndex.wrappedValue].wrappedValue += text
    }
}



struct LabelledTextField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    @Binding var isFocused: Bool  // Add this binding
    @Binding var isTouched: Bool
    var isValid: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(label)
                .font(.golosUIRegular(size: 20))
                .foregroundColor(.white)
            CustomTextField(placeholder: placeholder, text: $text, isFocused: $isFocused)  // Pass the binding to CustomTextField
                .frame(height: 44)
                .font(.golosUIRegular(size: 20))
                .onTapGesture {
                    self.isTouched = true
                }
                .onChange(of: text) { _ in
                    self.isTouched = true
                }
                .overlay(
                    HStack {
                        Spacer()
                        if isTouched && !isValid {
                            Image(systemName: "exclamationmark.circle.fill")
                                .resizable() // Allows resizing of the image
                                .scaledToFit() // Ensures the image scales proportionally
                                .frame(width: 32, height: 32) // Set the frame size as desired
                                .foregroundColor(Color.red)
                                .padding(.trailing, 16)
                        }
                    }
                )
        }
    }
}


private struct CustomTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var isFocused: Binding<Bool>
    

    func makeUIView(context: Context) -> PaddedTextField {
        let textField = PaddedTextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(named: "AppPrimaryDark") ?? .darkGray
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.textColor = .white
        textField.font = UIFont(name: "GolosUI-Regular", size: 20)
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.topInset = 20
        textField.bottomInset = 20
        textField.leftInset = 20
        textField.rightInset = 20

        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4),
            NSAttributedString.Key.font: UIFont(name: "GolosUI-Regular", size: 20)!
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)

        return textField
    }

    func updateUIView(_ uiView: PaddedTextField, context: Context) {
        uiView.text = text
        if isFocused.wrappedValue {
            uiView.layer.borderColor = UIColor(named: "AppSecondary")?.cgColor ?? UIColor.blue.cgColor
            uiView.layer.borderWidth = 8 // Increase border width when focused
            uiView.becomeFirstResponder()
        } else {
            uiView.layer.borderColor = UIColor.white.cgColor
            uiView.layer.borderWidth = 2 // Standard border width
            uiView.resignFirstResponder()
        }
    }
}


class PaddedTextField: UITextField {
    var topInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 0
    var rightInset: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}



#Preview {
    UserDataInputView()
}
