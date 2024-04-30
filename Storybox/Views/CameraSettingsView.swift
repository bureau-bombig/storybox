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
    @State private var focusedIndex: Int = 0

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
                        self.backAction()
                    }
                    .buttonStyle(focused: focusedIndex == 0)

                    Button("Confirm") {
                        self.nextAction()
                    }
                    .buttonStyle(focused: focusedIndex == 1)
                }
                .padding(.bottom)

                Spacer()
            }
            .background(Color.AppPrimary)
            .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.5) / 2)
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
            .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [self.backAction, self.nextAction]).frame(width: 0, height: 0, alignment: .center))
        }
    }
    private func nextAction() {
        appState.currentView = .answerQuestion
    }
    
    private func backAction() {
        appState.currentView = .chooseTopic
    }

    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int
        var actionHandlers: [() -> Void]

        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            let controller = KeyboardViewController()
            controller.focusedIndex = $focusedIndex
            controller.actionHandlers = actionHandlers
            return controller
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {}
    }
}

private class KeyboardViewController: UIViewController {
    var focusedIndex: Binding<Int>!
    var actionHandlers: [() -> Void]!
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    override func pressesBegan(_ presses: Set<UIPress>,
                               with event: UIPressesEvent?) {
        
        for press in presses {
            guard let key = press.key else { continue }
            print("Key pressed: \(key)")
            
            switch key.keyCode.rawValue {
            case (80): // left arrow key
                if focusedIndex.wrappedValue > 0 {
                    focusedIndex.wrappedValue -= 1
                }
            case (79): // right arrow key
                if focusedIndex.wrappedValue < actionHandlers.count - 1 {
                    focusedIndex.wrappedValue += 1
                }
            case (44): // space bar
                actionHandlers[focusedIndex.wrappedValue]()
            default:
                break
            }
        }
    }
}


extension Button {
    func buttonStyle(focused: Bool) -> some View {
        self.font(.golosUI(size: 18))
            .foregroundColor(Color.AppPrimary)
            .padding()
            .background(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(focused ? Color.AppSecondary : Color.AppPrimaryDark, lineWidth: focused ? 5 : 2)
            )
    }
}


#Preview {
    CameraSettingsView()
}
