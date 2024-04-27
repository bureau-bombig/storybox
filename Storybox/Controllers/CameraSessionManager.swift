//
//  CameraSessionManager.swift
//  Storybox
//
//  Created by User on 26.04.24.
//

import AVFoundation
import SwiftUI

class CameraSessionManager: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var session = AVCaptureSession()
    private var videoOutput = AVCaptureMovieFileOutput()
    var isConfigured = false

    override init() {
        super.init()
        setupCamera()
    }

    private func setupCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.isConfigured {
                print("CameraSessionManager: Session already configured.")
                return
            }

            self.session.beginConfiguration()
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.session.canAddInput(videoDeviceInput),
                  self.session.canAddOutput(self.videoOutput) else {
                DispatchQueue.main.async {
                    print("CameraSessionManager: Unable to initialize front camera or add output.")
                }
                self.session.commitConfiguration()
                return
            }

            self.session.addInput(videoDeviceInput)
            self.session.addOutput(self.videoOutput)
            self.session.sessionPreset = .iFrame960x540
            self.session.commitConfiguration()
            self.isConfigured = true

            self.startSession()
        }
    }

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.isConfigured && !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async {
                    print("CameraSessionManager: Session started.")
                }
            }
        }
    }

    func stopSession() {
        if self.session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.stopRunning()
                DispatchQueue.main.async {
                    print("CameraSessionManager: Session stopped.")
                }
            }
        }
    }

    func startRecording() {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("tempMovie.mov")
        
        DispatchQueue.global(qos: .userInitiated).async {
            try? FileManager.default.removeItem(at: fileURL)

            // Start configuring the video output connection for recording
            DispatchQueue.main.async {
                if let connection = self.videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
                    connection.videoOrientation = .landscapeRight  // Set to landscape mode
                }

                // Start recording after setting the orientation
                self.videoOutput.startRecording(to: fileURL, recordingDelegate: self)
            }
        }
    }
    func stopRecording() {
        videoOutput.stopRecording()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Error recording movie: \(error.localizedDescription)")
            } else {
                print("Recording finished successfully to \(outputFileURL)")
                VideoURLManager.shared.outputFileLocation = outputFileURL
            }
        }
    }
}

