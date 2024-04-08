import SwiftUI
import SwiftData
import Lottie

extension Date {
    var startOfDay: Date? {
        return Calendar.current.startOfDay(for: self)
    }
}

struct TreeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showTreeForm = false
    @State private var showMaxAlert = false
    @State private var showDeleteAlert = false
    @State private var selectedTree: Goal?
    
    @Query private var goals: [Goal]
    
    private func getImageTree(goal: Goal) -> some View {
        let consecutiveDays = findConsecutiveDays(entries: goal.entries)
        let growthMultiplier: Double = consecutiveDays >= 3 ? 1.5 : 1.0
        
        switch goal.progress * growthMultiplier {
        case 0..<0.4:
            return LottieView(animation: .named("Planting-1"))
                .currentProgress(1)
                .frame(maxHeight: 100)
        case 0.4..<0.7:
            return LottieView(animation: .named("Planting-2"))
                .currentProgress(1)
                .frame(maxHeight: 100)
        case 0.7..<1:
            return LottieView(animation: .named("Planting-3"))
                .currentProgress(1)
                .frame(maxHeight: 100)
        case 1...:
            return LottieView(animation: .named("Planting-4"))
                .currentProgress(1)
                .frame(maxHeight: 100)
        default:
            return LottieView(animation: .named("Planting-1"))
                .currentProgress(1)
                .frame(maxHeight: 100)
        }
    }
    
    private func findConsecutiveDays(entries: [Entry]) -> Int {
        let sortedEntries = entries.sorted(by: { $0.date < $1.date })
        var consecutiveDays = 1
        var previousDate: Date?

        for entry in sortedEntries {
            guard let currentDate = entry.date.startOfDay else { continue }
    
            if let prevDate = previousDate {
                if Calendar.current.isDate(prevDate, inSameDayAs: currentDate) {
                    continue
                }
                
                if let days = Calendar.current.dateComponents([.day], from: prevDate, to: currentDate).day, days == 1 {
                    consecutiveDays += 1
                    print(consecutiveDays)
                } else {
                    consecutiveDays = 1
                }
            }
            
            previousDate = currentDate
        }
        
        return consecutiveDays
    }
    
    private func shareAction() {
        let activityItems: [Any] = ["Check out my tree growth!"]
        
        let buttonRect = CGRect(x: UIScreen.main.bounds.width - 40, y: UIScreen.main.bounds.height - 40, width: 1, height: 1)
        guard let sourceView = UIApplication.shared.windows.first?.rootViewController?.view else { return }
        let shareSheet = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        shareSheet.popoverPresentationController?.sourceView = sourceView
        shareSheet.popoverPresentationController?.sourceRect = buttonRect
        UIApplication.shared.windows.first?.rootViewController?.present(shareSheet, animated: true, completion: nil)
    }
    
    var body: some View {
        VStack {
            if !goals.isEmpty {
                Text("My Money Trees")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(goals) { goal in
                        VStack {
                            ZStack {
                                getImageTree(goal: goal)
                                    .id("\(Date())")
                                
                                let consecutiveDays = findConsecutiveDays(entries: goal.entries)
                                
                                if consecutiveDays >= 3 {
                                    ZStack() {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.yellow)
                                            .frame(width: 90, height: 25)
                                        
                                        Text("1.5x Growth")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 8)
                                            .bold()
                                    }
                                    .offset(x: -20, y: -30)
                                }
                                
                                Button(action: {
                                    selectedTree = goal
                                    showDeleteAlert = true
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .padding(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .offset(x: 55, y: -30)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .size(width: 150, height: 150)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .frame(width: 150, height: 150)
                            .padding(.bottom, 20)
                            
                            Text(goal.name)
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                                .lineLimit(1)
                            
                            Text("$\(goal.target, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                if goals.count >= 6 {
                    Button(action: {
                        showMaxAlert.toggle()
                    }) {
                        Text("Add Tree")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    .alert(isPresented: $showMaxAlert) {
                        Alert(title: Text("Uh oh!"), message: Text("You're out of trees. Delete one to be able to add another."), dismissButton: .default(Text("OK")))
                    }
                } else {
                    Button(action: {
                        showTreeForm.toggle()
                    }) {
                        Text("Add Tree")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    .sheet(isPresented: $showTreeForm) {
                        AddTreeFormView(isPresented: $showTreeForm)
                    }
                }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 150, height: 150)
                    Image(systemName: "tree")
                        .font(.system(size: 75))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                Text("Plant a MoneyTree")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Text("Set your savings goal and")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                
                Text("watch your MoneyTree grow!")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                
                // Move the "Add Tree" button here
                Button(action: {
                    showTreeForm.toggle()
                }) {
                    Text("Add Tree")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(.green)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
                .sheet(isPresented: $showTreeForm) {
                    AddTreeFormView(isPresented: $showTreeForm)
                }
            }
            
            Spacer()
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Delete Tree"), message: Text("Are you sure you want to delete this tree?"), primaryButton: .destructive(Text("Delete")) {
                if let goal = selectedTree {
                    modelContext.delete(goal)
                }
            }, secondaryButton: .cancel())
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: shareAction) {
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
        )
    }
}

struct TreeView_Previews: PreviewProvider {
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
        
        return TreeView()
            .modelContainer(sharedModelContainer)
    }
}
