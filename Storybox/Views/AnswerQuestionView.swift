//
//  AnswerQuestionView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import AVKit

struct AnswerQuestionView: View {
    @ObservedObject private var cameraSessionManager = CameraSessionManager()
    @State private var isRecording = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("What does freedom mean to you?")
                        .font(.golosUIRegular(size: 42))
                        .foregroundColor(.white)
                        .padding()

                    ZStack(alignment: .bottomTrailing) {
                        QuestionVideoView()
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                            .background(Color.gray)
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
                                // cameraSessionManager.stopSession()
                            }
                    }

                    Button(isRecording ? "Press space to stop Recording" : "Press space to start recording") {
                        toggleRecording()
                    }
                    .styledButton(focused: true)
                }
                .background(Color.AppPrimary)
                .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.5) / 2)

                Spacer()
            }
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
            .background(KeyboardResponder().frame(width: 0, height: 0, alignment: .center))
            .onAppear {
                setupNotifications() // Set up the notification observer when the view appears
            }
        }
    }
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ToggleRecordingNotification"), object: nil, queue: .main) { [self] _ in
            self.toggleRecording()
        }
    }


    private func toggleRecording() {
            if isRecording {
                print("toggleRecording end")
                cameraSessionManager.stopRecording()
                cameraSessionManager.stopSession()
                isRecording = false
                appState.currentView = .confirmAnswer
            
            } else {
                print ("toggleRecording start")
                cameraSessionManager.startRecording()
                isRecording = true
            }
        }
    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            return KeyboardViewController()
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {}
    }

}

private class KeyboardViewController: UIViewController {
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            guard let key = press.key else { continue }
            if key.charactersIgnoringModifiers == " " { // Check if the space bar was pressed
                print("space bar pressed")
                NotificationCenter.default.post(name: NSNotification.Name("ToggleRecordingNotification"), object: nil)
            }
        }
        super.pressesBegan(presses, with: event)
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
