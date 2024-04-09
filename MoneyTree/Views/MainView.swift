//
//  MainView.swift
//  MoneyTree
//
//  Created by Stanley Cao on 2024-01-23.
//

import SwiftUI
import SwiftData
import SectionedQuery

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    @Query private var goals: [Goal]
    
    @SectionedQuery(\.day, sort: [SortDescriptor(\.date, order: .reverse)])
    private var sections: SectionedResults<String, Entry>

    @State private var showingSheet = false
    @State private var showingGoalSheet = false
    @State private var showingAlert = false
    @State private var deleteEntry: Entry?
    
    private var cardWidth = UIScreen.main.bounds.size.width / 2 - 24
    
    var body: some View {
        NavigationStack {
            List {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (spacing: 16) {
                        // Card views for goals
                        if goals.isEmpty {
                            VStack (spacing: 8) {
                                Image(systemName: "dollarsign.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .imageScale(.large)
                                    .foregroundColor(.green)
                                Text("Oops, no trees found!")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                Text("Create some cool goals!")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(width: cardWidth, height: 150)
                            .card()
                        } else {
                            ForEach(goals) { goal in
                                GoalProgress(goal: goal)
                                    .frame(width: cardWidth, height: 150)
                                    .id("\(Date())")
                            }
                        }
                        
                        // Button to add a new goal
                        Button(action: addGoal) {
                            VStack (spacing: 8) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                                Text("Add a new goal")
                                    .foregroundColor(.accentColor)
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .frame(width: cardWidth, height: 150)
                            .card()
                        }
                        .sheet(isPresented: $showingGoalSheet, content: {
                            AddTreeFormView(isPresented: $showingGoalSheet)
                        })
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                
                TipsView()
                
                // Entry list
                ForEach(sections) { section in
                    Section(header: Text(section.id)) {
                        ForEach(section) { item in
                            NavigationLink {
                                EntryDetailView(entry: item)
                            } label: {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(item.name)
                                    MoneyText(amount: item.amount, type: item.entryType)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                self.showingAlert = true
                                self.deleteEntry = section[index]
                            }
                        }
                        .alert(isPresented: self.$showingAlert) {
                            _ = self.deleteEntry!
                            return  Alert(title: Text("Delete Entry"), message: Text("Are you sure you want to delete this Entry?"), primaryButton: .destructive(Text("Delete")) {
                                withAnimation {
                                    modelContext.delete(deleteEntry!)
                                }
                            }, secondaryButton: .cancel())
                        }
                    }
                }
            }
            .navigationTitle("Spending")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: Settings()) {
                        Image(systemName: "gear")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button(action: addEntry) {
                        Label("Add Item", systemImage: "plus")
                    }.sheet(isPresented: $showingSheet, content: {
                        NavigationView {
                            EntryEditorView()
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        .presentationDetents([.medium])
                    })
                }
            }
        }
        .onAppear {
            if UserDefaults.standard.object(forKey: "isDarkMode") == nil {
                UserDefaults.standard.set(UIScreen.main.traitCollection.userInterfaceStyle == .dark, forKey: "isDarkMode")
            }
            
            if UserDefaults.standard.bool(forKey: "isDarkMode") {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            } else {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    private func addEntry() {
        showingSheet.toggle()
    }
    
    private func addGoal() {
        showingGoalSheet.toggle()
    }
}

#Preview {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Entry.self,
            Goal.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return MainView()
        .modelContainer(sharedModelContainer)
}


#Preview {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Entry.self,
            Goal.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return MainView()
        .modelContainer(sharedModelContainer)
}
