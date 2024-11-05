//
//  NonInteractiveVideoPlayer.swift
//  Storybox
//
//  Created by User on 21.10.24.
//


import SwiftUI
import AVFoundation

// Custom UIView that uses AVPlayerLayer as its backing layer
class VideoPlayerUIView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
}

// SwiftUI View that wraps the custom UIView
struct NonInteractiveVideoPlayer: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> VideoPlayerUIView {
        let view = VideoPlayerUIView()
        view.player = player
        view.playerLayer.videoGravity = .resizeAspect
        view.isUserInteractionEnabled = false  // Disable user interaction to prevent interception of keyboard events
        return view
    }

    func updateUIView(_ uiView: VideoPlayerUIView, context: Context) {
        uiView.player = player
    }
}
