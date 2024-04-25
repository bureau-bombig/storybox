//
//  IntroVideoView.swift
//  Storybox
//
//  Created by User on 24.04.24.
//

import SwiftUI
import AVKit

struct IntroVideoView: View {
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "IntroVideo", withExtension: "mp4")!)

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
                // Set up a loop for the video
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main
                ) { _ in
                    player.seek(to: .zero)
                    player.play()
                }
            }
            .edgesIgnoringSafeArea(.all)  // Ensure video fills the entire screen area
            .onDisappear {
                player.pause()
                NotificationCenter.default.removeObserver(self)
            }
    }
}

#Preview {
    IntroVideoView()
}
