//
//  CameraPreview.swift
//  Storybox
//
//  Created by User on 26.04.24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    var session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        context.coordinator.previewLayer = previewLayer
        context.coordinator.setOrientation(forceDefault: true) // Force default landscape orientation initially
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let previewLayer = context.coordinator.previewLayer else { return }
            previewLayer.frame = uiView.bounds
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, session: session)
    }

    class Coordinator: NSObject {
        var parent: CameraPreview
        var previewLayer: AVCaptureVideoPreviewLayer?
        var session: AVCaptureSession

        init(_ parent: CameraPreview, session: AVCaptureSession) {
            self.parent = parent
            self.session = session
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        @objc func handleOrientationChange() {
            setOrientation(forceDefault: false)
        }

        func setOrientation(forceDefault: Bool) {
            DispatchQueue.main.async {
                guard let connection = self.previewLayer?.connection, connection.isVideoOrientationSupported else {
                    if forceDefault {
                        // Retry setting orientation after a brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.setOrientation(forceDefault: true)
                        }
                    } else {
                        print("Orientation setup: Connection not ready or not supported.")
                    }
                    return
                }

                let deviceOrientation = UIDevice.current.orientation
                let videoOrientation: AVCaptureVideoOrientation? = {
                    switch deviceOrientation {
                    case .landscapeLeft:
                        return .landscapeRight
                    case .landscapeRight:
                        return .landscapeLeft
                    default:
                        return nil  // Ignore portrait and unknown orientations
                    }
                }()

                if let videoOrientation = videoOrientation {
                    connection.videoOrientation = videoOrientation
                    print("Orientation set to \(videoOrientation).")
                } else if forceDefault {
                    print("Initial orientation is portrait or undetected; setting to default landscape right.")
                    connection.videoOrientation = .landscapeRight // Default to a landscape orientation if not detected
                }
            }
        }
    }
}
