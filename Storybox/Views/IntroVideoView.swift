//
//  IntroVideoView.swift
//  Storybox
//
//  Created by User on 24.04.24.
//

import SwiftUI
import AVKit

struct IntroVideoView: View {
    @EnvironmentObject var appState: AppState
    private var player: AVPlayer?

    init() {
        // Initialize the video player with the URL of the video file
        let videoURL = Bundle.main.url(forResource: "IntroVideo", withExtension: "mp4")!
        player = AVPlayer(url: videoURL)
    }

    var body: some View {
        VideoPlayer(player: player)
            .overlay(Rectangle().foregroundColor(Color.black.opacity(0.001)).contentShape(Rectangle()))
            .onAppear {
                player?.play()
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player?.currentItem,
                    queue: .main
                ) { [self] _ in
                    // Move to the next view when the video finishes playing
                    appState.currentView = .keyboardInstructions
                }
            }
            .onDisappear {
                // Pause the video and clean up when the view disappears
                player?.pause()
                NotificationCenter.default.removeObserver(self)
            }
            .edgesIgnoringSafeArea(.all)  // Ensure video fills the entire screen area
    }
}




#Preview {
    IntroVideoView()
}
