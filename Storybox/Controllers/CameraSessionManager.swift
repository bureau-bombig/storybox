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
               do {
                   // Setup the video input
                   guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                         let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                         self.session.canAddInput(videoDeviceInput) else {
                       throw NSError(domain: "CameraSessionManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to initialize front camera or add output."])
                   }
                   self.session.addInput(videoDeviceInput)

                   // Setup the audio input
                   guard let audioDevice = AVCaptureDevice.default(for: .audio),
                         let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
                         self.session.canAddInput(audioInput) else {
                       throw NSError(domain: "CameraSessionManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to access microphone or add audio input."])
                   }
                   self.session.addInput(audioInput)

                   // Add video output
                   if self.session.canAddOutput(self.videoOutput) {
                       self.session.addOutput(self.videoOutput)
                   }

                   self.session.sessionPreset = .iFrame960x540
                   self.session.commitConfiguration()
                   self.isConfigured = true
                   self.startSession()
               } catch {
                   DispatchQueue.main.async {
                       print("Error setting up camera and audio inputs: \(error.localizedDescription)")
                   }
                   self.session.commitConfiguration()
               }
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
        print("Initializing recording...")
        DispatchQueue.global(qos: .userInitiated).async {
            try? FileManager.default.removeItem(at: fileURL)

            // Start configuring the video output connection for recording
            DispatchQueue.main.async {
                if let connection = self.videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
                    connection.videoOrientation = .landscapeRight  // Set to landscape mode
                }
                print("Attempting to start recording...")
                // Start recording after setting the orientation
                self.videoOutput.startRecording(to: fileURL, recordingDelegate: self)
            }
        }
    }
    func stopRecording() {
        videoOutput.stopRecording()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Attempting to save recording...")
        DispatchQueue.main.async {
            if let error = error {
                print("Error recording movie: \(error.localizedDescription)")
            } else {
                print("Recording finished successfully to \(outputFileURL)")
                FileURLManager.shared.outputFileLocation = outputFileURL
            }
        }
    }
}

