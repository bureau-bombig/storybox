//
//  AdminSettings.swift
//  Storybox
//
//  Created by User on 01.05.24.
//

import SwiftUI

struct AdminSettings: View {
    @EnvironmentObject var appState: AppState
    
    // Dummy data for the dropdown and checkboxes
    @State private var selectedOption = "Fest der Demokratie @ Bundeskanzleramt"
    let proveneces = ["Fest der Demokratie @ Bundeskanzleramt", "MS Wissensacht @ Wechselnde Häfen"]
    let options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9"]
    @State private var checkedStates = Array(repeating: false, count: 9)
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Einstellungen")
                    .font(.golosUIBold(size: 45))
                    .foregroundColor(.white)
                    
                
                Spacer() // Use Spacer to push content to opposite ends
                
                Button("Beiträge hochladen") {
                    // Action for upload
                    print("Upload action triggered")
                }
                .styledButton()
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20) {


                Text("Anlass oder Eventname")
                    .font(.golosUIRegular(size: 26))
                    .foregroundColor(.white)
                
                Picker("Options", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .tag(option)  // Make sure to tag each option correctly
                            .font(.golosUIRegular(size: 22))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(.white)
                .font(.golosUIRegular(size: 22))
                .background(.white)
                .padding(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                )


                VStack (      alignment: .leading) {
                    Text("Fragensets auswählen")
                        .font(.golosUIRegular(size: 26))  // Ensure golosUIRegular is correctly defined
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    // Setting up the grid layout
                    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)  // 3 columns
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        ForEach(0..<9, id: \.self) { index in
                            HStack {
                                Checkbox(isChecked: $checkedStates[index])
                                Text("Option \(index + 1)")
                                    .foregroundColor(.white)
                                    .font(.golosUIRegular(size: 22))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()// Change to your desired background color
            }
            .padding()
            
            HStack {
                Button("Updaten") {
                    // Reset settings action
                    print("Reset settings")
                }
                .styledButton()
                
                Spacer()
                
                Button("Zurücksetzen") {
                    // Save settings action
                    print("Save settings")
                }
                .styledButton()
                
                Spacer()
                
                Button("Speichern") {
                    // Save settings action
                    print("Save settings")
                }
                .styledButton()
                
                Spacer()
                
                Button("Schließen") {
                    // Save settings action
                    print("Save settings")
                }
                .styledButton()
            }
            .padding()      
        }
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppPrimary) // Use Primary color for background
        .edgesIgnoringSafeArea(.all)
    }
}

// Custom checkbox component
struct Checkbox: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(isChecked ? .green : .gray)
        }
    }
}

#Preview {
    AdminSettings()
}
