//
//  CustomVideoPlayer.swift
//  Storybox
//
//  Created by User on 29.04.24.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: UIViewRepresentable {
    var url: URL
    @Binding var player: AVPlayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black  // To see the frame of the player

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)

        context.coordinator.playerLayer = playerLayer

        // Load and display the first frame
        context.coordinator.loadThumbnail(url: url, in: view)

        if player == nil {
            // Initialize the player later to avoid state changes during view updates
            DispatchQueue.main.async {
                let newPlayer = AVPlayer(url: self.url)
                self.player = newPlayer
                playerLayer.player = newPlayer
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.playerLayer?.frame = uiView.bounds
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        var playerLayer: AVPlayerLayer?

        func loadThumbnail(url: URL, in view: UIView) {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 0.1, preferredTimescale: 600)
            imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, _, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        let thumbnailLayer = CALayer()
                        thumbnailLayer.contents = image
                        thumbnailLayer.frame = view.bounds
                        thumbnailLayer.contentsGravity = .resizeAspectFill
                        view.layer.insertSublayer(thumbnailLayer, below: self.playerLayer)
                    }
                }
            }
        }
    }
}
