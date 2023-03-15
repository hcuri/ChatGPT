//
//  ChatGPTManager.swift
//  ChatGPT
//
//  Created by Hector Curi on 3/14/23.
//

import Foundation
import Alamofire

class ChatGPTManager {
    private let apiKey: String
    private let apiUrl = "https://api.openai.com/v1/engines/davinci-codex/completions"
    
    init?() {
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
           let keysDict = NSDictionary(contentsOfFile: path),
           let key = keysDict["ChatGPTAPIKey"] as? String {
            apiKey = key
        } else {
            print("Error: Unable to load API key from APIKeys.plist")
            return nil
        }
    }
    
    func sendMessage(_ message: String, completion: @escaping (String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "model": "gpt-3.5-turbo",
            "prompt": "User: \(message)\nAI:",
            "max_tokens": 50,
            "n": 1,
            "stop": ["\n"]
        ]
        
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let jsonResponse = json as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let text = firstChoice["text"] as? String {
                    completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
