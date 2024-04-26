//
//  ThankYouView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI


struct ThankYouView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("Thank You!")
                        .font(.golosUI(size: 42))
                        .foregroundColor(.white)
                        .padding()

                    Text("Your contribution is highly valuable to our project. Feel free to share more thoughts!")
                        .font(.literata(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button("Start New") {
                        appState.currentView = .welcome
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.AppSecondary)
                    .cornerRadius(10)
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.AppPrimary)
                .cornerRadius(10)

                Spacer()
            }
            .background(Color.AppPrimary)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ThankYouView()
}
