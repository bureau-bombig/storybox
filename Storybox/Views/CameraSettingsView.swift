//
//  CameraSettingsView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import AVKit  // Import AVKit for camera preview functionality


struct CameraSettingsView: View {
    @State private var isAudioOnly = false  // State to toggle audio-only recording

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()  // Ensures content is centered vertically

                VStack(spacing: 20) {
                    Text("Adjust Camera Settings")
                        .font(.golosUI(size: 42))
                        .foregroundColor(.white)
                        .padding()

                    Text("Adjust the camera to ensure it's aligned with your height.")
                        .font(.literata(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing])

                    CameraPreview()  // Placeholder for camera preview
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5 * (9 / 16))  // Aspect ratio 16:9
                        .background(Color.gray)  // Simulates camera preview area
                        .cornerRadius(12)
                        .padding()

                    Toggle("Only Audio", isOn: $isAudioOnly)
                        .padding()
                        .frame(width: geometry.size.width * 0.5)  // Restrict toggle width to match the camera preview
                        .toggleStyle(SwitchToggleStyle(tint: Color.AppSecondary))
                        .foregroundColor(.white)

                    HStack {
                        Button("Back") {
                            // Action for the Back button
                        }
                        .buttonStyle()

                        Button("Confirm") {
                            // Action to confirm settings
                        }
                        .buttonStyle()
                    }
                    .padding(.bottom)
                }
                .background(Color.AppPrimary)  // Ensure the background color spans the entire VStack
                .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.5) / 2)  // Center content horizontally

                Spacer()  // Balances the vertical alignment
            }
            .background(Color.AppPrimary)  // Ensure the background color covers everything
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Custom button style for consistency
extension Button {
    func buttonStyle() -> some View {
        self.font(.golosUI(size: 18))
            .foregroundColor(.white)
            .padding()
            .background(Color.AppPrimaryDark)
            .cornerRadius(8)
    }
}

// Placeholder for camera preview functionality
struct CameraPreview: View {
    var body: some View {
        Text("Camera Preview")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
    }
}


#Preview {
    CameraSettingsView()
}
