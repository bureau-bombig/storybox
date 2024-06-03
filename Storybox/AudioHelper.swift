//
//  AudioHelper.swift
//  Storybox
//
//  Created by User on 01.06.24.
//

import AVFoundation

// Declare a variable to hold the audio player
var audioPlayer: AVAudioPlayer?

// Function to play the error sound
func playErrorSound() {
    if audioPlayer?.isPlaying == true {
        // The sound is already playing, do nothing
        return
    }
    
    DispatchQueue.global(qos: .background).async {
        if let soundURL = Bundle.main.url(forResource: "error-sound", withExtension: "mp3") {
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                player.play()
                DispatchQueue.main.async {
                    audioPlayer = player
                }
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Error: Sound file not found.")
        }
    }
}
