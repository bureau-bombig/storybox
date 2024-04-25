//
//  ChooseTopicView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

struct Topic {
    let image: String
    let title: String
    let description: String
}

let topics = [
    Topic(image: "nature", title: "Environment", description: "Discuss the freedom in the context of environmental conservation."),
    Topic(image: "politics", title: "Politics", description: "Explore freedoms related to political expression and activism."),
    Topic(image: "technology", title: "Technology", description: "Debate on the freedom of information and digital rights."),
    Topic(image: "education", title: "Education", description: "Consider the freedom of learning and access to information.")
]

struct ChooseTopicView: View {
    let topics: [Topic]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer() // Spacer to push content to the middle

                VStack(spacing: 20) {
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
                            ForEach(topics, id: \.title) { topic in
                                TopicCard(topic: topic)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 300)
                }

                Spacer() // Spacer to ensure the content is centered vertically
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // Make VStack fill GeometryReader
            .background(Color.AppPrimary) // Background applied here
        }
        .edgesIgnoringSafeArea(.all) // This applies the background beyond the safe area
    }
}

struct TopicCard: View {
    let topic: Topic

    var body: some View {
        VStack {
            Image(topic.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 150)
                .clipped()
            
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
    }
}

struct ChooseTopicView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTopicView(topics: topics)
    }
}
