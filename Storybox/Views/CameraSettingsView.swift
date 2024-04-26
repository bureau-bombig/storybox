//
//  CameraSettingsView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import AVFoundation

struct CameraSettingsView: View {
    @StateObject private var cameraSessionManager = CameraSessionManager()
    @State private var isAudioOnly = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                Text("Adjust Camera Settings")
                    .font(.golosUI(size: 42))
                    .foregroundColor(.white)
                    .padding()

                Text("Adjust the camera to ensure it's aligned with your height.")
                    .font(.literata(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                CameraPreview(session: cameraSessionManager.session)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                    .background(Color.gray)
                    .cornerRadius(12)
                    .padding()
                    .onAppear {
                            cameraSessionManager.startSession()
                        }
                    .onDisappear {
                            cameraSessionManager.stopSession()
                        }

                Toggle("Only Audio", isOn: $isAudioOnly)
                    .padding()
                    .frame(width: geometry.size.width * 0.5)
                    .toggleStyle(SwitchToggleStyle(tint: Color.AppSecondary))
                    .foregroundColor(.white)

                HStack {
                    Button("Back") {
                        appState.currentView = .chooseTopic
                    }
                    .buttonStyle()

                    Button("Confirm") {
                        appState.currentView = .answerQuestion
                    }
                    .buttonStyle()
                }
                .padding(.bottom)

                Spacer()
            }
            .background(Color.AppPrimary)
            .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.5) / 2)
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

extension Button {
    func buttonStyle() -> some View {
        self.font(.golosUI(size: 18))
            .foregroundColor(.white)
            .padding()
            .background(Color.AppPrimaryDark)
            .cornerRadius(8)
    }
}


#Preview {
    CameraSettingsView()
}
