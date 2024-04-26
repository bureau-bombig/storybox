//
//  ConfirmAnswerView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import AVKit

struct ConfirmAnswerView: View {
    @State private var isPlaying = false  // State to toggle video playback
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()  // Dynamic spacer to push content to the middle

                VStack() {
                    Text("Review Your Answer")
                        .font(.golosUI(size: 42))
                        .foregroundColor(.white)
                        .padding()

                    Text("Make sure you are satisfied with your recording before submitting.")
                        .font(.literata(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()

                    // VideoPreview adjusted for a 16:9 aspect ratio
                    VideoPreview()
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding()

                    HStack(spacing: 20) {
                        Button("Play Recording") {
                            isPlaying.toggle()
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: isPlaying ? .red : .green))
                        
                        Button("Delete Recording") {
                            appState.currentView = .answerQuestion
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: .red))
                        
                        Button("Submit Recording") {
                            appState.currentView = .thankYou
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: .blue))
                    }
                }
                .frame(width: geometry.size.width * 0.5)  // Ensure the content block doesn't exceed the intended width
                .background(Color.AppPrimary)  // Apply background color to this frame

                Spacer()  // Dynamic spacer to balance the vertical alignment
            }
            .frame(width: geometry.size.width)  // Fill the width of GeometryReader
            .background(Color.AppPrimary)  // Background color for the entire view
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Placeholder view for video preview
struct VideoPreview: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray)  // Simulates the video area
            .overlay(
                Text("Video Preview")
                    .foregroundColor(.white)
            )
    }
}

#Preview {
    ConfirmAnswerView()
}
