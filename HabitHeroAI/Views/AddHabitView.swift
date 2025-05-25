//
//  AddHabitView.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/23/25.
//

import SwiftUI

struct AddHabitView: View {
    @ObservedObject var viewModel: HabitViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $viewModel.title)
                TextField("Category", text: $viewModel.category)
                DatePicker("Remainder Time", selection: $viewModel.remainderTime, displayedComponents: .hourAndMinute)
            }
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addHabit(contextData: viewContext)
                        viewModel.title = ""
                        viewModel.category = ""
                        viewModel.remainderTime = Date()
                        dismiss()
                    } label: {
                        Text("Save")
                    }

                }
            }
        }
    }
}

#Preview {
    AddHabitView(viewModel: HabitViewModel())
}
