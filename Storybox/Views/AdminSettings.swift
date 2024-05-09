//
//  AdminSettings.swift
//  Storybox
//
//  Created by User on 01.05.24.
//

import SwiftUI

struct AdminSettings: View {
    @EnvironmentObject var appState: AppState
    
    @State private var selectedOption: String?
    @State private var checkedStates: [Bool] = []
    @State private var isUpdating = false
    @State private var forceUpdate = UUID()

    var body: some View {
        VStack(spacing: 20) {
            if isUpdating {
                ProgressView("Updating... Please wait")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding()
            }
            HeaderView()
            
            content
            
            FooterView()
        }
        .id(forceUpdate)
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppPrimary)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            loadSettings()
        }
        .onChange(of: appState.provenances) { _ in
            loadSettings()
        }
        .onChange(of: appState.topics) { _ in
            resetTopicSelections() // Reset topic selections whenever topics change
            loadSettings()
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Anlass oder Eventname")
                .font(.golosUIRegular(size: 26))
                .foregroundColor(.white)
            
            setupEventPicker()
            
            Text("Fragensets auswählen")
                .font(.golosUIRegular(size: 26))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            setupTopicsGrid()
        }
    }

    private func HeaderView() -> some View {
        HStack {
            Text("Einstellungen")
                .font(.golosUIBold(size: 45))
                .foregroundColor(.white)
                
            Spacer()
            
            Button("Beiträge hochladen") {
                appState.currentView = .adminUpload
            }
            .styledButton()
        }
    }

    private func FooterView() -> some View {
        HStack {
            Button("Updaten") {
                updateData()
            }
            .styledButton()
            
            Spacer()
            
            Button("Schließen") {
                saveProvenanceSelection()
                saveTopicSelections()
                appState.currentView = .welcome
            }
            .styledButton()
        }
        .padding()
    }
    

    private func updateData() {
        isUpdating = true  // Start showing the updating indicator
        print("Update button clicked")
        let group = DispatchGroup()

        group.enter()
        appState.fetchProvenancesFromAPI {
            group.leave()
        }
        
        group.enter()
        appState.fetchTopicsFromAPI {
            self.resetTopicSelections()
            group.leave()
        }
        
        group.enter()
        appState.fetchQuestionsFromAPI {
            group.leave()
        }

        group.notify(queue: .main) {
            print("Before resetSettings: \(appState.topics.map { $0.title })")
            self.resetSettings()
            print("After resetSettings: Topics count: \(appState.topics.count), CheckedStates: \(self.checkedStates)")
            self.forceUIUpdate()
            self.isUpdating = false  // Stop showing the updating indicator
        }
    }

    private func resetSettings() {
        selectedOption = nil
        checkedStates = Array(repeating: true, count: appState.topics.count)
        AdminSettingsManager.shared.resetSettings()
        forceUIUpdate()  // Force UI to refresh
    }

    
    private func resetTopicSelections() {
        checkedStates = Array(repeating: true, count: appState.topics.count)
    }


    private func forceUIUpdate() {
        print("Forcing UI update")
        DispatchQueue.main.async {
            self.forceUpdate = UUID()  // Triggering re-render
            print("UI update triggered.")
        }
    }
    
    private func setupEventPicker() -> some View {
        Picker("Options", selection: $selectedOption) {
            Text("Select an Event").tag(String?.none as String?)
            ForEach(appState.provenances, id: \.self) { provenance in
                Text("\(provenance.title ?? "No Title") @ \(provenance.spatial ?? "No Spatial")").tag(provenance.title as String?)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.25), lineWidth: 1))
        .onChange(of: selectedOption) { newValue in
            if let newProvenance = appState.provenances.first(where: { $0.title == newValue }) {
                AdminSettingsManager.shared.saveSelectedProvenanceID(Int(newProvenance.id))
            } else {
                AdminSettingsManager.shared.saveSelectedProvenanceID(nil) // Clear setting if no event is selected
            }
        }
    }

    private func setupTopicsGrid() -> some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
            ForEach(appState.topics.indices, id: \.self) { index in
                Checkbox(isChecked: Binding(
                    get: { checkedStates.count > index ? checkedStates[index] : false },
                    set: { newValue in
                        if index < checkedStates.count {
                            checkedStates[index] = newValue
                            saveTopicSelections()
                        }
                    }
                ), label: appState.topics[index].title ?? "Unknown")
            }
        }
        .padding()
        .onReceive(appState.$topics) { topics in
            print("Received new topics update. Current topics: \(topics.map { $0.title ?? "Unknown" })")
            if checkedStates.count != topics.count {
                print("Adjusting checkedStates due to count change from \(checkedStates.count) to \(topics.count).")
                checkedStates = Array(repeating: true, count: topics.count)
            }
        }
    }

    private func saveProvenanceSelection() {
        if let selected = selectedOption,
           let provenance = appState.provenances.first(where: { $0.title == selected }) {
            AdminSettingsManager.shared.saveSelectedProvenanceID(Int(provenance.id))
        } else {
            AdminSettingsManager.shared.saveSelectedProvenanceID(nil)
        }
    }


    private func saveTopicSelections() {
        let selectedIDs = appState.topics.enumerated().compactMap { index, topic -> Int? in
            return checkedStates[index] ? Int(topic.id) : nil
        }
        AdminSettingsManager.shared.saveSelectedTopicIDs(selectedIDs)
    }
    
    private func loadSettings() {
        if let provenanceID = AdminSettingsManager.shared.getSelectedProvenanceID(),
           let provenance = appState.provenances.first(where: { Int($0.id) == provenanceID }) {
            selectedOption = provenance.title
        } else {
            selectedOption = nil
        }

        // Reinitialize checked states every time settings are loaded
        checkedStates = Array(repeating: true, count: appState.topics.count)
        let selectedTopicIDs = AdminSettingsManager.shared.getSelectedTopicIDs()
        for (index, topic) in appState.topics.enumerated() {
            checkedStates[index] = selectedTopicIDs.contains(Int(topic.id))
        }
    }
}

struct Checkbox: View {
    @Binding var isChecked: Bool
    var label: String
    
    var body: some View {
        Button(action: {
            print("Checkbox for \(label) toggled from \(isChecked) to \(!isChecked)")
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .green : .gray)
                Text(label)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    AdminSettings()
}
