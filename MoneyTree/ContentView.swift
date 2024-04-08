//
//  ContentView.swift
//  MoneyTree
//
//  Created by Stanley Cao on 2024-01-23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel: BadgesViewModel
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            StatisticView(month: Date.now)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.xaxis")
                }
                .tag(1)
            
            TreeView()
                .tabItem {
                    Label("Trees", systemImage: "tree")
                }
                .tag(2)
            
            BadgesView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Achievements", systemImage: "trophy")
                }
                .tag(3)
        }
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
    
   return ContentView(viewModel: BadgesViewModel())
        .modelContainer(sharedModelContainer)
}
