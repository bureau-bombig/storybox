//
//  ChooseTopicView.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import CoreData

struct ChooseTopicView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState
    @State private var focusedIndex: Int? = 0
    @State private var topics: [Topic] = []
    @State private var topicsCount: Int = 0
    
    // Fetching topic data from CoreData
    private func fetchTopics() {
        let topicIDs = AdminSettingsManager.shared.getSelectedTopicIDs()
        guard !topicIDs.isEmpty else {
            print("No topic IDs are stored.")
            return
        }
        let request: NSFetchRequest<Topic> = Topic.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", topicIDs)
        do {
            self.topics = try viewContext.fetch(request)
            self.topicsCount = topics.count
        } catch {
            print("Failed to fetch topics: \(error.localizedDescription)")
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack (alignment: .bottom, spacing: 120) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Wähle dein")
                            .font(.golosUIBold(size: 45))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Text("Thema")
                            .font(.literata(size: 45))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Text("Wähle ein Thema und bestätige mit Leertaste. Jedes Thema hat Fragen die du beantworten kannst.")
                        .font(.golosUIRegular(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                }
                
                Spacer()
                
                ScrollViewReader { scrollView in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(topics.indices, id: \.self) { index in
                                TopicCard(topic: topics[index], isFocused: $focusedIndex.wrappedValue == index)
                                    .id(index)
                                    .onTapGesture {
                                        focusedIndex = index
                                        nextView()
                                    }
                            }
                        }
                    }
                    // React to changes in focusedIndex to scroll into view
                    .onChange(of: focusedIndex) { newIndex in
                        withAnimation {
                            scrollView.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                HStack () {
                    Image("arrowkey-left")
                    Spacer()
                    Image("arrowkey-right")
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.AppPrimary)
            .background(KeyboardResponder(focusedIndex: $focusedIndex, topicsCount: topicsCount, action: nextView).frame(width: 0, height: 0))
        }
        .padding(60)
        .background(Color.AppPrimary)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.async {
                self.fetchTopics()
            }
        }
    }
    
    private func nextView() {
        if let index = focusedIndex, index >= 0 && index < topics.count {
            appState.selectedTopic = topics[index]
            appState.currentView = .cameraSettings
        } else {
            print("No topic selected or invalid index")
        }
    }
    
    private struct KeyboardResponder: UIViewControllerRepresentable {
        @Binding var focusedIndex: Int?
        let topicsCount: Int
        var action: () -> Void
        
        internal func makeUIViewController(context: Context) -> KeyboardViewController {
            return KeyboardViewController(focusedIndex: $focusedIndex, topicsCount: topicsCount, action: action)
        }

        internal func updateUIViewController(_ uiViewController: KeyboardViewController, context: Context) {
            uiViewController.topicsCount = topicsCount
        }
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
                if let index = focusedIndex.wrappedValue, index >= 0 && index < topicsCount {
                    action()  // Trigger the action associated with the selected topic
                } else {
                    print("Invalid topic selection or index out of range")
                }
            default:
                break
            }
        }
    }
}

struct TopicCard: View {
    let topic: Topic
    var isFocused: Bool
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            Text(topic.title ?? "No Title")
                .font(.golosUIBold(size: 32))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            Text(topic.topicDescription ?? "No Description")
                .font(.golosUIRegular(size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineSpacing(8)
        }
        .frame(width: 350, height: 200)
        .padding(48)
        .background(Color.AppPrimaryDark)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.AppSecondary : Color.white, lineWidth: isFocused ? 10 : 2)
        )
    }
}
 
struct ChooseTopicView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTopicView()
    }
}
