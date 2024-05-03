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
    @ObservedObject var videoURLManager = VideoURLManager.shared
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var focusedIndex: Int = 0  // 0 for Play, 1 for Delete, 2 for Submit


    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                Text("Review Your Answer")
                    .foregroundColor(.white)
                    .padding()

                Text("Make sure you are satisfied with your recording before submitting.")
                    .font(.literata(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                if let url = videoURLManager.outputFileLocation {
                    CustomVideoPlayerView(url: url, player: $player)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding()
                } else {
                    Text("Waiting for recording to finish or no recording found")
                        .foregroundColor(.white)
                        .padding()
                }

                controlButtons()
                Spacer()
            }
            .frame(width: geometry.size.width)
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
            .background(KeyboardResponder(focusedIndex: $focusedIndex, actionHandlers: [togglePlayback, deleteRecording, submitRecording]).frame(width: 0, height: 0, alignment: .center))

        }
    }

    /*
    private func setupPlayer(url: URL) {
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        
        // Set up a notification to reset the player when the video finishes playing
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main) { [self] _ in
                self.player?.seek(to: .zero, completionHandler: { _ in
                    self.isPlaying = false // Ensure the button reflects the correct state
                })
            }
    }
     */

    @ViewBuilder
    private func controlButtons() -> some View {
        HStack(spacing: 20) {
            Button(isPlaying ? "Pause Recording" : "Play Recording") {
                togglePlayback()
            }
            .styledButton(focused: focusedIndex == 0)

            Button("Delete Recording") {
                deleteRecording()
            }
            .styledButton(focused: focusedIndex == 1)
            
            Button("Submit Recording") {
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
        videoURLManager.outputFileLocation = nil
    }

    private func submitRecording() {
        appState.currentView = .thankYou
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


#Preview {
    ConfirmAnswerView()
}
