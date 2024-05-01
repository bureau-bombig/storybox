//
//  AppState.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var currentView: AppView = .welcome
}

enum AppView {
    case welcome, introVideo, keyboardInstructions, userDataInput, chooseTopic, cameraSettings, answerQuestion, confirmAnswer, thankYou, adminSettings, adminUpload
}
