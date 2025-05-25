//
//  HabitListView.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/22/25.
//

import Foundation
import SwiftUI
import CoreData

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: false)], animation: .default)
    private var habits: FetchedResults<Habit>
    @StateObject private var viewModel = HabitViewModel()
    
    var body: some View {
        NavigationStack {
            let completionRatio = viewModel.calculateCompletionPercentage(for: Array(habits))
            if viewModel.isLoadingSuggestion {
                ProgressView("Getting smart ideas...")
                    .padding()
            }
            Button {
                Task {
                    await viewModel.fetchAISuggestion(habits: Array(habits))
                }
            } label: {
                HStack {
                    Image(systemName: "lightbulb")
                    Text("Suggest a habit")
                }
            }

            PieChartView(percentage: completionRatio)
                .padding(.vertical)
            List {
                ForEach(habits) { habit in
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            if let title = habit.title, let category = habit.category {
                                Text(title)
                                    .font(.headline)
                                Text(category)
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                        Button {
                            viewModel.toggleHabitCompleted(for: habit, context: viewContext)
                        } label: {
                            Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(habit.isCompletedToday ? .green : .gray)
                                .imageScale(.large)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { habits[$0] }.forEach { habit in
                        viewModel.deleteHabit(habit, contextData: viewContext)
                    }
                }
                Spacer()
            }
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddHabitView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("AI Suggestion", isPresented: $viewModel.isShowingAlert, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(viewModel.showingSuggestion ?? "Sorry! Try again")
            })
        }
    }

}

#Preview {
    HabitListView()
}
