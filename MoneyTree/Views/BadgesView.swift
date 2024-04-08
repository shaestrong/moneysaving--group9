import SwiftUI
import SwiftData

struct BadgesView: View {
    @State var viewModel: BadgesViewModel
    @Query private var goals: [Goal]
    @State private var showShareSheet = false

    var body: some View {
        VStack {
            Text("Achievements")
                .font(.title)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.listEarnedBadges) { badge in
                        badge.view
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    // Toggle the state to show the share sheet
                    showShareSheet.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(.trailing)
                .padding(.bottom, 30)
                .padding(.trailing, 20)
            }
        }
        .onAppear {
            viewModel.checkAchievements(goals: goals)
        }
        // Present the share sheet when the state is true
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: ["Check out my achievements!"])
        }
    }
}

struct BadgesView_Previews: PreviewProvider {
    static var previews: some View {
        let sharedModelContainer: ModelContainer = {
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
        return BadgesView(viewModel: BadgesViewModel())
            .modelContainer(sharedModelContainer)
    }
}
