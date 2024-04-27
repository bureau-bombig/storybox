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

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                Text("Review Your Answer")
                    .font(.golosUI(size: 42))
                    .foregroundColor(.white)
                    .padding()

                Text("Make sure you are satisfied with your recording before submitting.")
                    .font(.literata(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                if let url = videoURLManager.outputFileLocation {
                    VideoPlayer(player: player)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding()
                        .onAppear {
                            setupPlayer(url: url)
                        }
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
        }
    }

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

    @ViewBuilder
    private func controlButtons() -> some View {
        HStack(spacing: 20) {
            Button(isPlaying ? "Pause Recording" : "Play Recording") {
                togglePlayback()
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: .green))

            Button("Delete Recording") {
                appState.currentView = .answerQuestion
                player?.pause()
                player = nil
                videoURLManager.outputFileLocation = nil
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: .red))
            
            Button("Submit Recording") {
                appState.currentView = .thankYou
                player?.pause()
                player = nil
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: .blue))
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
}


#Preview {
    ConfirmAnswerView()
}
