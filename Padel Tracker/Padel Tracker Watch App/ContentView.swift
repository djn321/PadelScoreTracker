import SwiftUI

struct ContentView: View {
    @StateObject private var match = MatchModel()
    @StateObject private var historyManager = MatchHistoryManager()
    @State private var showResetConfirmation = false
    @State private var showEndGameConfirmation = false
    @State private var showHistory = false

    var body: some View {
        NavigationStack {
            TabView {
                // Page 1: Main scoring interface
                ScoreView(match: match)

                // Page 2: Options
                OptionsView(
                    match: match,
                    historyManager: historyManager,
                    showResetConfirmation: $showResetConfirmation,
                    showEndGameConfirmation: $showEndGameConfirmation,
                    showHistory: $showHistory
                )
            }
            .tabViewStyle(.page)
            .confirmationDialog("Reset Match?", isPresented: $showResetConfirmation) {
                Button("Reset", role: .destructive) {
                    match.resetMatch()
                }
                Button("Cancel", role: .cancel) {}
            }
            .confirmationDialog("End Game?", isPresented: $showEndGameConfirmation) {
                Button("End & Save", role: .destructive) {
                    let savedMatch = match.createSavedMatch()
                    historyManager.save(match: savedMatch)
                    match.resetMatch()
                }
                Button("Cancel", role: .cancel) {}
            }
            .navigationDestination(isPresented: $showHistory) {
                HistoryView(historyManager: historyManager)
            }
            .onAppear {
                match.onMatchComplete = { savedMatch in
                    historyManager.save(match: savedMatch)
                }
            }
        }
    }
}

struct ScoreView: View {
    @ObservedObject var match: MatchModel

    var body: some View {
        VStack(spacing: 4) {
            // Score display
            VStack(spacing: 2) {
                Text(match.statusText)
                    .font(.caption2)
                    .foregroundColor(.secondary)

                HStack {
                    Text("Sets:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(match.setsDisplay)
                        .font(.caption)
                        .bold()
                }

                HStack {
                    Text("Games:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(match.gamesDisplay)
                        .font(.caption)
                        .bold()
                }

                Text(match.pointsDisplay)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
            }
            .padding(.top, 4)

            Spacer()

            // Tap zones
            if match.matchOver {
                Button("New Match") {
                    match.resetMatch()
                }
                .buttonStyle(.borderedProminent)
            } else {
                HStack(spacing: 4) {
                    Button(action: {
                        match.scorePointUs()
                    }) {
                        VStack {
                            Text("Us")
                                .font(.headline)
                            Text("+")
                                .font(.title3)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)

                    Button(action: {
                        match.scorePointThem()
                    }) {
                        VStack {
                            Text("Them")
                                .font(.headline)
                            Text("+")
                                .font(.title3)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.orange)
                }
                .frame(maxHeight: 60)
            }

            // Swipe hint
            if !match.matchOver {
                Text("Swipe for options")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
            }
        }
    }
}

struct OptionsView: View {
    @ObservedObject var match: MatchModel
    @ObservedObject var historyManager: MatchHistoryManager
    @Binding var showResetConfirmation: Bool
    @Binding var showEndGameConfirmation: Bool
    @Binding var showHistory: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text("Options")
                .font(.headline)

            if !match.matchOver {
                Button("End Game") {
                    showEndGameConfirmation = true
                }
                .buttonStyle(.bordered)
                .tint(.orange)
            }

            Button("History") {
                showHistory = true
            }
            .buttonStyle(.bordered)

            if !match.matchOver {
                Button("Reset") {
                    showResetConfirmation = true
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
        .padding()
    }
}

struct HistoryView: View {
    @ObservedObject var historyManager: MatchHistoryManager

    var body: some View {
        Group {
            if historyManager.matches.isEmpty {
                VStack {
                    Text("No matches yet")
                        .foregroundColor(.secondary)
                    Text("Complete a match to see it here")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                List {
                    ForEach(historyManager.matches) { match in
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(match.usWon ? "Won" : "Lost")
                                    .font(.caption)
                                    .foregroundColor(match.usWon ? .green : .red)
                                    .bold()
                                Spacer()
                                Text(match.setsDisplay)
                                    .font(.caption)
                                    .bold()
                            }
                            Text(match.setScoresDisplay)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(match.formattedDate)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete(perform: historyManager.delete)
                }
            }
        }
        .navigationTitle("History")
    }
}

#Preview {
    ContentView()
}
