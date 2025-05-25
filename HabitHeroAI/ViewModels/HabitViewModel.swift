//
//  HabitViewModel.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/22/25.
//

import Foundation
import CoreData
import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var category: String = ""
    @Published var remainderTime: Date = Date()
    @Published var isLoadingSuggestion: Bool = false
    @Published var showingSuggestion: String? = nil
    @Published var isShowingAlert: Bool = false
    
    func addHabit(contextData: NSManagedObjectContext) {
        let newHabit = Habit(context: contextData)
        newHabit.id = UUID()
        newHabit.title = title
        newHabit.category = category
        newHabit.createdAt = Date()
        newHabit.remainderTime = remainderTime
        newHabit.isCompletedToday = false

        do {
            try contextData.save()
            NotificationService.shared.scheduleNotification(habit: newHabit)
        } catch {
            print("❌ Failed to save habit: \(error)")
        }
    }

    func deleteHabit(_ habit: Habit, contextData: NSManagedObjectContext) {
        contextData.delete(habit)
        try? contextData.save()
    }

    func calculateCompletionPercentage(for habits: [Habit]) -> Double {
        guard !habits.isEmpty else { return 0.0 }
        let completed = habits.filter { $0.isCompletedToday }.count
        return Double(completed) / Double(habits.count)
    }

    func toggleHabitCompleted(for habit: Habit, context: NSManagedObjectContext) {
        do {
            habit.isCompletedToday.toggle()
            try context.save()
        } catch {

        }
    }

    @MainActor
    func fetchAISuggestion(habits: [Habit]) async {
        let ai = OpenAISuggester()
        isLoadingSuggestion = true
        do {
            let suggestion = try await ai.suggestHabit(from: Array(habits))
            self.showingSuggestion = suggestion
        } catch {
            showingSuggestion = "❌ Failed to get suggestion: \(error.localizedDescription)"
        }
        isLoadingSuggestion = false
        isShowingAlert = true
    }
}
