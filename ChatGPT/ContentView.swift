//
//  ContentView.swift
//  ChatGPT
//
//  Created by Hector Curi on 3/14/23.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var messages: [Message] = []

    var body: some View {
        VStack {
            // Display conversation
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages) { message in
                        MessageView(content: message.content, isUser: message.isUser)
                    }
                }
            }
            .padding()

            // User input and send button
            HStack {
                TextField("Type your message...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane")
                        .padding()
                }
            }
        }
        .padding(.bottom)
    }

    private func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)

        if !trimmedInput.isEmpty {
            let userMessage = Message(content: trimmedInput, isUser: true)
            messages.append(userMessage)

            // Call the ChatGPT API and display the response (details in step 4)

            userInput = ""
        }
    }
}

// This is preview code that came with the project, will review later
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
                .padding()
                .background(isUser ? Color.blue : Color.gray)
                .foregroundColor(isUser ? .white : .black)
                .cornerRadius(8)
            
            if !isUser {
                Spacer()
            }
        }
    }
}
