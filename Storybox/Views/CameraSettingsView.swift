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
                HStack (alignment: .bottom, spacing: 120) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Kamera")
                            .font(.golosUIBold(size: 45))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Text("einstellen")
                            .font(.literata(size: 45))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Text("Stelle die Kamera so ein, dass du / ihr gut im Bild zu sehen seid. Frisur richten nicht vergessen.")
                        .font(.golosUIRegular(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
                
                HStack(spacing: 20) {
                    
                        CameraPreview(session: cameraSessionManager.session)
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                            .background(Color.gray)
                            .cornerRadius(12)
                            .overlay(
                                Group {
                                    if isAudioOnly {
                                        // Show fallback image when audio only is enabled
                                        Image("no-camera-fallback")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                                            .cornerRadius(12)
                                    }
                                }
                            )
                            .onAppear {
                                cameraSessionManager.startSession()
                            }
                            .onDisappear {
                                cameraSessionManager.stopSession()
                            }
                   
                    
                    HStack() {
                        Image("double-arrow")
                        Text("Bist du gut im Bild zusehen? In der Kabine findest du mehr infos darüber")
                            .font(.golosUIRegular(size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(8)
                    }
                }
                
                Spacer()

                HStack () {
                    Button("Zurück") {
                        self.backAction()
                    }
                    .styledButton(focused: focusedIndex == 0)
                    .padding(.trailing, 20)
                    
                    HStack(spacing: 8) {
                        Toggle("", isOn: $isAudioOnly)
                            .toggleStyle(ColoredBackgroundToggleStyle(onColor: Color.AppSecondary, offColor: Color.AppPrimaryLight, isFocused: focusedIndex == 1))
                            .padding(.trailing, 8)
                        Text("Nur Audio aufnehmen")
                            .foregroundColor(.white)
                    }
                    .fixedSize()
                    
                    Spacer()
                    
                    Button("Bestätigen") {
                        self.nextAction()
                    }
                    .styledButton(focused: focusedIndex == 2)
                }
            }
            .padding(80)
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
            .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [self.backAction, self.nextAction], isAudioOnly: $isAudioOnly).frame(width: 0, height: 0, alignment: .center))
        }
    }
    private func nextAction() {
        appState.isAudioOnly = isAudioOnly
        appState.currentView = .answerQuestion
    }
    
    private func backAction() {
        appState.currentView = .chooseTopic
    }

    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int
        var actionHandlers: [() -> Void]
        @Binding var isAudioOnly: Bool

        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            KeyboardViewController(focusedIndex: $focusedIndex, actionHandlers: actionHandlers, isAudioOnly: $isAudioOnly)
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {}
    }
}

private class KeyboardViewController: UIViewController {
    var focusedIndex: Binding<Int>!
    var actionHandlers: [() -> Void]!
    var isAudioOnly: Binding<Bool>
    
    // Custom initializer that takes required bindings
    init(focusedIndex: Binding<Int>, actionHandlers: [() -> Void], isAudioOnly: Binding<Bool>) {
        self.focusedIndex = focusedIndex
        self.actionHandlers = actionHandlers
        self.isAudioOnly = isAudioOnly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
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
                if focusedIndex.wrappedValue < 2{
                    focusedIndex.wrappedValue += 1
                }
            case (44): // space bar
                
                if focusedIndex.wrappedValue == 0 {
                    actionHandlers[0]()
                }
                if focusedIndex.wrappedValue == 1 {  // Assuming the toggle is at index 1
                    isAudioOnly.wrappedValue.toggle()
                }
                if focusedIndex.wrappedValue == 2 {
                    actionHandlers[1]()
                }
            default:
                break
            }
        }
    }
}

struct ColoredBackgroundToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var thumbColor: Color = .white
    var isFocused: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 52, height: 32)
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isFocused ? Color.AppSecondary : Color.clear, lineWidth: 5)
                )
                .animation(.spring(), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

#Preview {
    CameraSettingsView()
}
