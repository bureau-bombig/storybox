//
//  ChooseTopicView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

struct ChooseTopicView: View {
    @EnvironmentObject var appState: AppState  // Ensuring we can trigger navigation

    struct Topic: Identifiable {
        let id = UUID()
        let image: String
        let title: String
        let description: String
    }

    private let topics: [Topic] = [
        Topic(image: "topic-nature", title: "Environment", description: "Discuss the freedom in the context of environmental conservation."),
        Topic(image: "topic-politics", title: "Politics", description: "Explore freedoms related to political expression and activism."),
        Topic(image: "topic-technology", title: "Technology", description: "Debate on the freedom of information and digital rights."),
        Topic(image: "topic-education", title: "Education", description: "Consider the freedom of learning and access to information.")
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Choose a Topic")
                    .font(.golosUI(size: 42))
                    .foregroundColor(.white)
                    .padding(.horizontal)

                Text("Select a topic that interests you to see related questions.")
                    .font(.literata(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(topics) { topic in
                            TopicCard(topic: topic)
                                .onTapGesture {
                                    appState.currentView = .cameraSettings  // Assuming this is the next view
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 300)

                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.AppPrimary)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct TopicCard: View {
    let topic: ChooseTopicView.Topic

    var body: some View {
        VStack {
            Image(topic.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 150)
                .clipped()
                .grayscale(1.0)
                .overlay(
                    Color.AppPrimary
                        .blendMode(.hardLight)
                )

            Text(topic.title)
                .font(.golosUI(size: 24))
                .foregroundColor(.white)
                .padding(.top)

            Text(topic.description)
                .font(.literata(size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .background(Color.AppPrimaryDark)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 2)
        )
        .shadow(radius: 5)
        .frame(width: 250)
        // .onTapGesture added here if needed or keep it in the ScrollView's HStack
    }
}


struct ChooseTopicView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTopicView()
    }
}
