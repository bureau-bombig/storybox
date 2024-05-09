//
//  CameraSessionManager.swift
//  Storybox
//
//  Created by User on 26.04.24.
//

import AVFoundation
import SwiftUI
import VideoToolbox


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
                   
                   // Attempt to use an external camera first
                   let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.external], mediaType: .video, position: .unspecified)
                   let devices = discoverySession.devices
                   let videoDevice: AVCaptureDevice?
                   if let externalDevice = devices.first {
                       videoDevice = externalDevice
                       self.session.sessionPreset = self.session.canSetSessionPreset(.iFrame1280x720) ? .iFrame1280x720 : .high
                   } else {
                       // Fallback to built-in front camera if no external cameras are found
                       videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
                       self.session.sessionPreset = .iFrame960x540 // Preset for built-in camera
                   }

                   guard let videoDevice = videoDevice,
                         let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                         self.session.canAddInput(videoDeviceInput) else {
                       throw NSError(domain: "CameraSessionManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to initialize camera or add output."])
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

                   self.session.commitConfiguration()
                   self.isConfigured = true
                   self.startSession()
                   
                   DispatchQueue.main.async {
                       self.printSupportedSessionPresets()  // Print formats after setup
                   }
               } catch {
                   DispatchQueue.main.async {
                       print("Error setting up camera and audio inputs: \(error.localizedDescription)")
                   }
                   self.session.commitConfiguration()
               }
           }
       }
    
    func printSupportedSessionPresets() {
        guard let videoDeviceInput = session.inputs.compactMap({ $0 as? AVCaptureDeviceInput }).first(where: { $0.device.hasMediaType(.video) }) else {
            print("No video device input found in session.")
            return
        }

        let presets: [AVCaptureSession.Preset] = [
            .photo, .high, .medium, .low,
            .hd1280x720, .hd1920x1080, .hd4K3840x2160,
            .iFrame960x540, .iFrame1280x720,
            .vga640x480, .cif352x288
        ]

        print("Supported presets for device \(videoDeviceInput.device.localizedName):")
        for preset in presets {
            if videoDeviceInput.device.supportsSessionPreset(preset) {
                print("\(preset.rawValue) is supported.")
            } else {
                print("\(preset.rawValue) is NOT supported.")
            }
        }
    }

    
    
    private func configureCameraDevice(_ videoDevice: AVCaptureDevice) throws {
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              self.session.canAddInput(videoDeviceInput) else {
            throw NSError(domain: "CameraSessionManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unable to configure camera device input."])
        }
        self.session.addInput(videoDeviceInput)
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

extension CameraSessionManager {
    func printAvailableCameraFormats() {
        guard let videoDeviceInput = session.inputs.compactMap({ $0 as? AVCaptureDeviceInput }).first(where: { $0.device.hasMediaType(.video) }) else {
            print("No video device input found in session.")
            return
        }

        let videoDevice = videoDeviceInput.device
        print("Available formats for device \(videoDevice.localizedName):")
        for format in videoDevice.formats {
            let formatDescription = format.formatDescription
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            let frameRates = format.videoSupportedFrameRateRanges.map { $0.minFrameRate...$0.maxFrameRate }
            let maxFrameRate = frameRates.map { $0.upperBound }.max() ?? 0
            let minFrameRate = frameRates.map { $0.lowerBound }.min() ?? 0
            let codecType = CMFormatDescriptionGetMediaSubType(formatDescription)
            let codecString = fourCCToString(codecType: codecType)

            print("Codec: \(codecString), Resolution: \(dimensions.width)x\(dimensions.height), FPS: \(minFrameRate)-\(maxFrameRate)")
        }
    }

    private func fourCCToString(codecType: FourCharCode) -> String {
        let bytes: [CChar] = [
            CChar((codecType >> 24) & 0xFF),
            CChar((codecType >> 16) & 0xFF),
            CChar((codecType >> 8) & 0xFF),
            CChar(codecType & 0xFF),
            0
        ]
        return String(cString: bytes, encoding: .ascii) ?? "Unknown"
    }
}
