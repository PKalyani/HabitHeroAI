//
//  OpenAISuggester.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/23/25.
//

import Foundation

class OpenAISuggester {
    private let apiKey = "Your-API-Key"

    func suggestHabit(from habits: [Habit]) async throws -> String {
        let habitsList = habits
                   .compactMap { $0.title?.trimmingCharacters(in: .whitespacesAndNewlines) }
                   .prefix(10)
                   .joined(separator: ", ")
        let prompt = "Based on these habits: \(habitsList). Suggest one new healthy daily habit."
        print("📝 Payload size: \(prompt.count) characters")
        guard prompt.count < 3000 else {
            print("❌ Too many habits. Please remove a few and try again.")
            return ""
        }
        let url = URL(string: "https://api.openai.com/v1/responses")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "model": "gpt-4.1",
            "input": prompt
//            "messages": [
//                "role" : "user", "content": prompt
//            ],
//            "max_tokens": 100,
//            "temperature": 0.7
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        // 🚨 Optional debug log
       print("🔢 Request size: \(jsonData.count) bytes")
       if jsonData.count > 8000 {
           throw URLError(.dataLengthExceedsMaximum)
       }
        request.httpBody = jsonData
        let (data, res) = try await URLSession.shared.data(for: request)


        guard let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = response["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let suggestion = message["content"] as? String else {
            throw URLError(.badServerResponse)
        }
        return suggestion.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
