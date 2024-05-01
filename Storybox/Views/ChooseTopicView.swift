//
//  ChooseTopicView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI

struct ChooseTopicView: View {
    @EnvironmentObject var appState: AppState  // Ensuring we can trigger navigation
    @State private var focusedIndex: Int? = 0

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
                    .font(.golosUIRegular(size: 42))
                    .foregroundColor(.white)
                    .padding(.horizontal)

                Text("Select a topic that interests you to see related questions.")
                    .font(.literata(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(topics.indices, id: \.self) { index in
                            TopicCard(topic: topics[index], isFocused: focusedIndex == index)
                                .onTapGesture {
                                    nextView()  // Action when tapping or selecting with space
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
        .background(KeyboardResponder(focusedIndex: $focusedIndex, topicsCount: topics.count, action: nextView).frame(width: 0, height: 0))
    }
    
    private func nextView() {
        // Here you might save the selected topic for later processing
        // Comment: Save selected topic here later
        appState.currentView = .cameraSettings
    }
    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int?
        let topicsCount: Int
        var action: () -> Void
        
        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            return KeyboardViewController(focusedIndex: $focusedIndex, topicsCount: topicsCount, action: action)
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {}
    }

}

private class KeyboardViewController: UIViewController {
    var focusedIndex: Binding<Int?>!
    var topicsCount: Int!
    var action: () -> Void
    
    // Custom initializer to set up the required properties
    init(focusedIndex: Binding<Int?>, topicsCount: Int, action: @escaping () -> Void) {
        self.focusedIndex = focusedIndex
        self.topicsCount = topicsCount
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func pressesBegan(_ presses: Set<UIPress>,
                               with event: UIPressesEvent?) {
        
        for press in presses {
            guard let key = press.key else { continue }
            print("Key pressed: \(key)")
            
            switch key.keyCode.rawValue {
            case (80): // left arrow key
                if let index = focusedIndex.wrappedValue, index > 0 {
                    focusedIndex.wrappedValue = index - 1
                }
            case (79): // right arrow key
                if let index = focusedIndex.wrappedValue, index < topicsCount - 1 {
                    focusedIndex.wrappedValue = index + 1
                }
            case (44): // space bar
                if focusedIndex.wrappedValue != nil {
                    action()  // Trigger the action associated with the selected topic
                }
            default:
                break
            }
        }
    }
}

struct TopicCard: View {
    let topic: ChooseTopicView.Topic
    var isFocused: Bool

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
                .font(.golosUIRegular(size: 24))
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
                .stroke(isFocused ? Color.AppSecondary : Color.white, lineWidth: isFocused ? 5 : 2) // Focus indication
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
