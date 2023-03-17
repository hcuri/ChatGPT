//
//  ContentView.swift
//  ChatGPT
//
//  Created by Hector Curi on 3/14/23.
//

import SwiftUI

struct ContentView: View {
    let chatGPTUrl = URL(string: "https://chat.openai.com/chat")!

    var body: some View {
        WebView(url: chatGPTUrl)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
