//
//  GoalPicker.swift
//  MoneyTree
//
//  Created by Stanley Cao on 2024-02-14.
//

import SwiftUI
import SwiftData

struct GoalPicker: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    
    var entry: Entry
    
    @Query private var goals: [Goal]
    
    private func associateGoal (goal: Goal) {
        entry.goal = goal
        dismiss()
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(goals) { goal in
                    Button (action: { associateGoal(goal: goal) }) {
                        GoalListItem(goal: goal)
                    }.buttonStyle(.plain)
                }
            }
            
            // Remove the association with the goal
            Button("Remove Contribution", role: .destructive) {
                showingAlert.toggle()
            }
        }
        .navigationTitle(entry.goal != nil ? "Change a Goal" : "Select a Goal") // Set title based on whether an association exists
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Remove Contribution"),
                message: Text("Are you sure you want to remove this contribution?"),
                primaryButton: .destructive(Text("Remove")) {
                    entry.goal = nil
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Schema([Entry.self, Goal.self]), configurations: config)
    
    let entry = Entry(
        timestamp: Date(),
        entryType: .income,
        amount: 20.00,
        name: "Grandma",
        notes: "Grandma gave me the money for a tripple whopper combo. However I will save it for buying a Tesla!",
        date: Date()
    )
    
    container.mainContext.insert(entry)
    
    return GoalPicker(entry: entry)
}
