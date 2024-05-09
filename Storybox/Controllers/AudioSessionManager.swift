//
//  AudioSessionManager.swift
//  Storybox
//
//  Created by User on 07.05.24.
//

import AVFoundation

class AudioSessionManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?

    override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("tempAudio.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100, // Higher sample rate for better audio quality
            AVNumberOfChannelsKey: 1, // Mono audio, set to 2 for stereo if needed
            AVEncoderBitRateKey: 128000, // Higher bit rate for better quality
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            print("Audio recording started...")
        } catch {
            print("Audio recording could not start: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        if let url = audioRecorder?.url {
            print("Audio recording stopped, file saved at: \(url)")
            FileURLManager.shared.outputFileLocation = url
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully.")
            FileURLManager.shared.outputFileLocation = recorder.url
        } else {
            print("Recording finished unsuccessfully.")
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Encode error occurred: \(error.localizedDescription)")
        }
    }
}
