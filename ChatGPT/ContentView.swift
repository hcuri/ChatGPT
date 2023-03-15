//
//  ContentView.swift
//  ChatGPT
//
//  Created by Hector Curi on 3/14/23.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var messages: [Message] = []
    private let chatGPTManager: ChatGPTManager?

    init() {
        chatGPTManager = ChatGPTManager()
    }

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    LazyVStack {
                        ForEach(messages) { message in
                            MessageView(content: message.content, isUser: message.isUser)
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
            HStack {
                TextField("Type your message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom)
        }
        .padding()
    }

    private func sendMessage() {
        let trimmedInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedInput.isEmpty {
            let userMessage = Message(content: trimmedInput, isUser: true)
            messages.append(userMessage)
            inputText = ""

            chatGPTManager?.sendMessage(trimmedInput) { response in
                DispatchQueue.main.async {
                    if let responseText = response {
                        let aiMessage = Message(content: responseText, isUser: false)
                        messages.append(aiMessage)
                    } else {
                        // Handle error or show a default message
                    }
                }
            }
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct MessageView: View {
    let content: String
    let isUser: Bool

    var body: some View {
        HStack {
            if isUser {
                Spacer()
            }
            Text(content)
                .padding(10)
                .background(isUser ? Color.blue : Color.gray)
                .foregroundColor(isUser ? .white : .black)
                .cornerRadius(10)
            if !isUser {
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
