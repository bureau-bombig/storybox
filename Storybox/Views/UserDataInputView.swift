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
    

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer();
                    Text("User Data Input")
                        .font(.golosUI(size: 42))
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
                            appState.currentView = .keyboardInstructions
                        }
                        .styledButton(textColor: .white, backgroundColor: Color.AppPrimaryDark)

                        Button("Confirm") {
                            appState.currentView = .chooseTopic
                        }
                        .styledButton(textColor: .white, backgroundColor: Color.AppSecondary)
                    }
                    .padding(.bottom, 40)
                    
                    Spacer();
                }
                .frame(minWidth: geometry.size.width) // Ensure content width matches GeometryReader's width
            }
            .frame(width: geometry.size.width) // Set ScrollView's width to GeometryReader's width
        }
        .background(Color.AppPrimary) // Set the background on the GeometryReader
        .edgesIgnoringSafeArea(.all) // Ensure it covers the entire screen area, including edges
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
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.white)
                .padding(.horizontal)
                .frame(width: 500)
        }
    }
}

extension Button {
    func styledButton(textColor: Color, backgroundColor: Color) -> some View {
        self.font(.golosUI(size: 18))
            .foregroundColor(textColor)
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.AppPrimaryDark, lineWidth: 2)
            )
    }
}


#Preview {
    UserDataInputView()
}
