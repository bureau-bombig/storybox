//
//  ConfirmAnswerView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import AVKit

struct ConfirmAnswerView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var fileURLManager = FileURLManager.shared
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var focusedIndex: Int = 2  // 0 for Play, 1 for Delete, 2 for Submit


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

                HStack (alignment: .bottom, spacing: 120) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Deine")
                            .font(.golosUIBold(size: 45))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Text("Antwort")
                            .font(.literata(size: 45))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Text("Schau dir deine Antwort noch einmal an. Speichere die Antwort ab oder lösche die Antwort und sprich sie neu ein.")
                        .font(.golosUIRegular(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
                
                if let url = fileURLManager.outputFileLocation {
                    CustomVideoPlayerView(url: url, player: $player)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .overlay(
                            Group {
                                if appState.isAudioOnly {
                                    // Show fallback image when audio only is enabled
                                    Image("no-camera-fallback")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                                        .cornerRadius(12)
                                }
                            }
                        )
                } else {
                    Text("Waiting for recording to finish or no recording found")
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()
                controlButtons()
            
            }
            .padding(80)
            .frame(width: geometry.size.width)
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
            .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [togglePlayback, deleteRecording, submitRecording]).frame(width: 0, height: 0, alignment: .center))

        }
    }

    @ViewBuilder
    private func controlButtons() -> some View {
        HStack(spacing: 20) {
            Button(isPlaying ? "Stoppen" : "Abspielen") {
                togglePlayback()
            }
            .styledButton(focused: focusedIndex == 0)

            Button("Löschen") {
                deleteRecording()
            }
            .styledButton(focused: focusedIndex == 1)
            
            Button("Einreichen") {
                submitRecording()
            }
            .styledButton(focused: focusedIndex == 2)
        }
    }

    private func togglePlayback() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            isPlaying = false
        } else {
            if player.currentTime() == player.currentItem?.duration {
                player.seek(to: .zero) // If at end, reset before playing
            }
            player.play()
            isPlaying = true
        }
    }
    
    private func deleteRecording() {
        appState.currentView = .answerQuestion
        player?.pause()
        player = nil
        fileURLManager.outputFileLocation = nil
    }

    private func submitRecording() {
        ItemService.shared.createItem(from: appState, recordingURL: fileURLManager.outputFileLocation)
        if appState.currentQuestionIndex < relevantQuestions.count - 1 {
            // Move to the next question
            appState.currentQuestionIndex += 1
            appState.currentView = .answerQuestion
        } else {
            // No more questions, show thank you screen
            appState.currentView = .thankYou
        }
        player?.pause()
        player = nil
    }

    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int
        var actionHandlers: [() -> Void]

        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            let controller = KeyboardViewController(focusedIndex: $focusedIndex, actionHandlers: actionHandlers)
            return controller
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {
            // Update logic if necessary, for example, when actionHandlers change
        }
    }
}

private class KeyboardViewController: UIViewController {
    var focusedIndex: Binding<Int>!
    var actionHandlers: [() -> Void]!

    // Custom initializer that accepts focusedIndex and actionHandlers
    init(focusedIndex: Binding<Int>, actionHandlers: [() -> Void]) {
        self.focusedIndex = focusedIndex
        self.actionHandlers = actionHandlers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        for press in presses {
            guard let key = press.key else { continue }
            AppManager.shared.resetIdleTimer() 
            
            switch key.keyCode.rawValue {
            case (80): // left arrow key
                if focusedIndex.wrappedValue > 0 {
                    focusedIndex.wrappedValue -= 1
                } else {
                    playErrorSound()
                }
            case (79): // right arrow key
                if focusedIndex.wrappedValue < actionHandlers.count - 1 {
                    focusedIndex.wrappedValue += 1
                } else {
                    playErrorSound()
                }
            case 44, 40: // space bar
                actionHandlers[focusedIndex.wrappedValue]()
            default:
                break
            }
            if key.modifierFlags.intersection([.control, .shift, .alternate]).contains([.control, .shift, .alternate]) && key.charactersIgnoringModifiers == "q" {
                AppManager.shared.restartApplication()
            }
        }
    }
}


#Preview {
    ConfirmAnswerView()
}
