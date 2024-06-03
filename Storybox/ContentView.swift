//
//  ContentView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        viewForCurrentState(appState.currentView)
            .gesture(DragGesture(minimumDistance: 1, coordinateSpace: .global)  // Increase minimum distance slightly
                        .onChanged { _ in AppManager.shared.resetIdleTimer() }
                        .onEnded { _ in AppManager.shared.resetIdleTimer() }
                        .simultaneously(with: DragGesture().onChanged { _ in })
            )
            .onTapGesture {
                AppManager.shared.resetIdleTimer()
            }
            .onAppear {
                AppManager.shared.resetIdleTimer()
            }
            .statusBar(hidden: true)  // Hide status bar
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
            AdminSettings()
        case .adminUpload:
            AdminUpload()
        }
    }
}

