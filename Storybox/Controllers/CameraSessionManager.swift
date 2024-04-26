//
//  CameraSessionManager.swift
//  Storybox
//
//  Created by User on 26.04.24.
//

import AVFoundation
import SwiftUI

class CameraSessionManager: ObservableObject {
    @Published var session = AVCaptureSession()
    var isConfigured = false

    init() {
        print("CameraSessionManager initialized.")
        setupCamera()
    }

    func setupCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.isConfigured {
                print("CameraSessionManager: Session already configured.")
                return
            }

            self.session.beginConfiguration()

            // Specifically use the front camera
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.session.canAddInput(videoDeviceInput) else {
                print("CameraSessionManager: Unable to initialize front camera.")
                self.session.commitConfiguration()
                return
            }

            self.session.addInput(videoDeviceInput)
            self.session.sessionPreset = .iFrame960x540  // Choose a session preset that is suitable for your needs
            self.session.commitConfiguration()
            self.isConfigured = true

            // Start the session after configuration
            self.startSession()
        }
    }

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.isConfigured && !self.session.isRunning {
                self.session.startRunning()
                print("CameraSessionManager: Session started.")
            }
        }
    }

    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
                print("CameraSessionManager: Session stopped.")
            }
        }
    }
}
