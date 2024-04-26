//
//  AnswerQuestionView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import AVKit

struct AnswerQuestionView: View {
    @StateObject private var cameraSessionManager = CameraSessionManager()
    @State private var isRecording = false
    @EnvironmentObject var appState: AppState
   

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()  // Ensures content is centered vertically

                VStack(spacing: 20) {
                    Text("What does freedom mean to you?")
                        .font(.golosUI(size: 42))
                        .foregroundColor(.white)
                        .padding()

                    ZStack(alignment: .bottomTrailing) {
                        QuestionVideoView()  // Placeholder for the question video
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))  // Aspect ratio 16:9
                            .background(Color.gray)  // Simulates video area
                            .cornerRadius(12)
                            .padding()
                        
                        
                        CameraPreview(session: cameraSessionManager.session)
                            .frame(width: 150, height: 150 * (9 / 16))
                            .border(Color.white, width: 2)
                            .padding(.trailing, 30)
                            .padding(.bottom, 30)
                            .onAppear {
                                    cameraSessionManager.startSession()
                                }
                            .onDisappear {
                                    cameraSessionManager.stopSession()
                                }
                        
                    }
                    
                    if !isRecording {
                        Button("Start Recording") {
                            isRecording = true
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color.green))
                        
                        Button("Skip Questions") {
                            appState.currentView = .confirmAnswer
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color.gray))
                    } else {
                        Button("Stop Recording") {
                            isRecording = false
                            appState.currentView = .confirmAnswer
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color.red))
                    }
                }
                .background(Color.AppPrimary)  // Consistent background color
                .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.5) / 2)  // Center content horizontally

                Spacer()  // Balances the vertical alignment
            }
            .background(Color.AppPrimary)  // Ensure the background color covers everything
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Custom Button Style adapted from CameraSettingsView
struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// Placeholder views for video components
struct QuestionVideoView: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)  // Placeholder color for video
            .overlay(
                Text("Question Video")
                    .foregroundColor(.white)
            )
    }
}

#Preview {
    AnswerQuestionView()
}
