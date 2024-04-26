//
//  ContentView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        viewForCurrentState(appState.currentView)
    }
    
    @ViewBuilder
    private func viewForCurrentState(_ state: AppView) -> some View {
        switch state {
        case .welcome:
            WelcomeView()
        case .introVideo:
            IntroVideoView()
        case .keyboardInstructions:
            KeyboardInstructionsView()
        case .userDataInput:
            UserDataInputView()
        case .chooseTopic:
            ChooseTopicView()
        case .cameraSettings:
            CameraSettingsView()
        case .answerQuestion:
            AnswerQuestionView()
        case .confirmAnswer:
            ConfirmAnswerView()
        case .thankYou:
            ThankYouView()
        case .adminSettings:
            // AdminSettingsView()
            Text("This view is under construction")
        case .adminUpload:
            Text("This view is under construction")
            // AdminUploadView()
        }
    }
}

