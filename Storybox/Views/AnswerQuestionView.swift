//
//  AnswerQuestionView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import AVKit
import CoreData


struct AnswerQuestionView: View {
    @State private var isRecording = false
    @EnvironmentObject var appState: AppState
    @State private var focusedIndex = 0
    @State private var enableKeyboard = true // false for enable keyboard only after video ended
    @ObservedObject private var cameraSessionManager = CameraSessionManager()
    @ObservedObject private var audioSessionManager = AudioSessionManager()
    @State private var versionKey: UUID = UUID()
    @State private var recordingTimer: Timer?


    
    // Computed property to get relevant questions based on the selected topic
    private var relevantQuestions: [Question] {
        guard let topic = appState.selectedTopic else { return [] }
        guard let questionIDs = topic.questionIDs as? [Int] else { return [] }
        return appState.questions.filter { question in
            questionIDs.contains(Int(question.id))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 20) {
                    if let question = relevantQuestions[safe: appState.currentQuestionIndex] {
                        HStack () {
                        
                            Text("Frage: \(question.title ?? "No Question available")")
                                .id(appState.currentQuestionIndex)
                                .font(.golosUIBold(size: 45))
                                .foregroundColor(.white)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(12)
                                .onAppear() {
                                    print(relevantQuestions)
                                    print("######### THIS QUESTION ##########")
                                    print(question.id)
                                    print(question.title ?? "No title available")
                                    print(question.localURL ?? "No localUrl available")
                                }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .topTrailing) {
                                // Question Video View
                                if let question = relevantQuestions[safe: appState.currentQuestionIndex] {
                                    QuestionVideoView(question: question, enableKeyboard: $enableKeyboard)
                                        .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6 * (9 / 16))
                                        .background(Color.gray)
                                        .cornerRadius(12)
                                }

                                // Camera Preview
                                if !appState.isAudioOnly {
                                    CameraPreview(session: cameraSessionManager.session)
                                        .frame(width: 324, height: 324 * (9 / 16))  // Adjust size as needed
                                        .background(Color.black)
                                        .cornerRadius(8)  // Smaller corner radius for smaller view
                                        .border(Color.white, width: 2)  // Optional: add a border for better visibility
                                        .offset(x: 250, y: (geometry.size.height / 2) - (324 * (9 / 16)) / 2)  // Adjust these values to fine-tune the overlap position
                                } else {
                                    Image("no-camera-fallback")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 324, height: 324 * (9 / 16))  // Adjust size as needed
                                        .cornerRadius(12)
                                        .border(Color.white, width: 2)
                                        .offset(x: 250, y: (geometry.size.height / 2) - (324 * (9 / 16)) / 2)
                                }
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onAppear {
                                if !appState.isAudioOnly {
                                    cameraSessionManager.startSession()
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 40) {
                        Spacer()

                        if !isRecording {
                            Button("Frage überspringen") {
                                skipQuestion()
                            }
                            .styledButton(focused: focusedIndex == 0 && enableKeyboard)
                            .opacity(enableKeyboard ? 1 : 0.5)
                        }
                        
                        Button(isRecording ? "Aufnahme beenden" : "Aufnahme starten") {
                            toggleRecording()
                        }
                        .styledButton(focused: focusedIndex == 1)
                        .opacity(enableKeyboard ? 1 : 0.5)

                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(80)
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.AppPrimary)
            .id(versionKey)
            .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [skipQuestion, toggleRecording], isRecording: $isRecording, enableKeyboard: $enableKeyboard).frame(width: 0, height: 0, alignment: .center))
            .onAppear {
                setupNotifications() // Set up the notification observer when the view appears
                print("View appeared with question index: \(appState.currentQuestionIndex)")
                print("Version Key: \(versionKey)")
            }
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ToggleRecordingNotification"), object: nil, queue: .main) { [self] _ in
            self.toggleRecording()
        }
    }
    
    private func skipQuestion() {
        if appState.currentQuestionIndex < relevantQuestions.count - 1 {
            appState.currentQuestionIndex += 1
            versionKey = UUID()  // Update the version key to force a full view refresh
        } else {
            appState.currentView = .thankYou
        }
    }

    private func toggleRecording() {
        print("toggleRecording \(isRecording ? "end" : "start"), isAudioOnly: \(appState.isAudioOnly)")
        if isRecording {
            if appState.isAudioOnly {
                print("Stopping audio recording...")
                audioSessionManager.stopRecording()
                recordingTimer?.invalidate()
                recordingTimer = nil
            } else {
                print("Stopping video recording...")
                cameraSessionManager.stopRecording()
                cameraSessionManager.stopSession()
                recordingTimer?.invalidate()
                recordingTimer = nil
            }
            isRecording = false
            appState.currentView = .confirmAnswer
        } else {
            if appState.isAudioOnly {
                print("Starting audio recording...")
                audioSessionManager.startRecording()
                recordingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
                    AppManager.shared.resetIdleTimer()
                }
            } else {
                print("Starting video recording...")
                cameraSessionManager.startRecording()
                recordingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
                    AppManager.shared.resetIdleTimer()
                }
            }
            isRecording = true
        }
    }

    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int
        var actionHandlers: [() -> Void]
        var isRecording: Binding<Bool>
        var enableKeyboard: Binding<Bool>
       

        func makeUIViewController(context: Context) -> KeyboardViewController {
            return KeyboardViewController(focusedIndex: $focusedIndex, actionHandlers: actionHandlers, isRecording: isRecording, enableKeyboard: enableKeyboard)
        }

        func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {}
    }

}

private class KeyboardViewController: UIViewController {
    var focusedIndex: Binding<Int>!
    var actionHandlers: [() -> Void]!
    var isRecording: Binding<Bool>
    var enableKeyboard: Binding<Bool>

    required init(focusedIndex: Binding<Int>, actionHandlers: [() -> Void], isRecording: Binding<Bool>, enableKeyboard: Binding<Bool>) {
        self.focusedIndex = focusedIndex
        self.actionHandlers = actionHandlers
        self.isRecording = isRecording
        self.enableKeyboard = enableKeyboard
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var canBecomeFirstResponder: Bool {
        true
    }
    
    

    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            AppManager.shared.resetIdleTimer() 
            guard let key = press.key else { continue }
            guard enableKeyboard.wrappedValue else { return }

                print("Key pressed: \(key)")
            print("isRecording: \(isRecording.wrappedValue)")
                
                switch key.keyCode.rawValue {
                case (80): // left arrow key
                    if !isRecording.wrappedValue && focusedIndex.wrappedValue > 0 {
                        focusedIndex.wrappedValue -= 1
                    }
                case (79): // right arrow key
                    if !isRecording.wrappedValue && focusedIndex.wrappedValue < 1 {
                        focusedIndex.wrappedValue += 1
                    }
                case (44): // space bar
                    
                    if focusedIndex.wrappedValue == 0 {
                        actionHandlers[0]()
                    }
                    if focusedIndex.wrappedValue == 1 {  // Assuming the toggle is at index 1
                        NotificationCenter.default.post(name: NSNotification.Name("ToggleRecordingNotification"), object: nil)
                    }
                default:
                    break
                }
            if key.modifierFlags.intersection([.control, .shift, .alternate]).contains([.control, .shift, .alternate]) && key.charactersIgnoringModifiers == "q" {
                AppManager.shared.restartApplication()
            }
            }
        }
}


private struct QuestionVideoView: View {
    var question: Question  // Use a regular variable, not a binding
    @Binding var enableKeyboard: Bool
    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                setupPlayer()
            }
            .onChange(of: question) { newQuestion in
                setupPlayer()
            }
    }

    private func setupPlayer() {
        player?.pause()
        player = nil
        NotificationCenter.default.removeObserver(self)

        guard let url = URL(string: question.localURL ?? ""),
              let fileName = url.pathComponents.last,
              let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Invalid URL or file name extraction failed.")
            enableKeyboard = true
            return
        }

        let videoFilePath = documentsDirectory.appendingPathComponent("question_vids").appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: videoFilePath) {
            let fileURL = URL(fileURLWithPath: videoFilePath)
            player = AVPlayer(url: fileURL)
            player?.play()
            observePlayer(player)
        } else {
            print("Video file does not exist: \(videoFilePath)")
            enableKeyboard = true
        }
    }

    private func observePlayer(_ player: AVPlayer?) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
            enableKeyboard = true
        }
        NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime, object: player?.currentItem, queue: .main) { notification in
            print("Failed to play video to end: \(notification.userInfo?["error"] ?? "Unknown error")")
            enableKeyboard = true
        }
    }
}



extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    AnswerQuestionView()
}
