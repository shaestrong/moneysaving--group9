import SwiftUI
import SwiftData

struct BadgesView: View {
    @State var viewModel: BadgesViewModel
    @Query private var goals: [Goal]
    @State private var showShareSheet = false
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.listEarnedBadges.isEmpty {
                    ZStack {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 150, height: 150)
                        Image(systemName: "trophy")
                            .font(.system(size: 75))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    Text("You don't have any achievements yet!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Start your journey by creating a new goal!")
                        .font(.headline)
                        .padding(.bottom)
                    
                    Button(action: {
                        selectedTab = 2
                    }) {
                        Text("Create a new goal!")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 10) {
                            ForEach(viewModel.listEarnedBadges) { badge in
                                badge.view
                                    .frame(width: UIScreen.main.bounds.width - 20)
                            }
                        }
                        .padding(.horizontal)
                    }
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
            .navigationTitle("Achievements")
            .onAppear {
                viewModel.checkAchievements(goals: goals)
            }
            // Present the share sheet when the state is true
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: ["Check out my achievements!"])
            }
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
        @State var selectedTab: Int = 3
        return BadgesView(viewModel: BadgesViewModel(), selectedTab: $selectedTab)
            .modelContainer(sharedModelContainer)
    }
}
