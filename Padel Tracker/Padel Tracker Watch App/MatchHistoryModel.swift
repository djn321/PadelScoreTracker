import Foundation
import SwiftUI
import Combine

struct SavedMatch: Codable, Identifiable {
    let id: UUID
    let date: Date
    let usSets: Int
    let themSets: Int
    let setScores: [String]  // e.g. ["6-4", "3-6", "6-2"]
    let usWon: Bool

    var setsDisplay: String {
        return "\(usSets) - \(themSets)"
    }

    var setScoresDisplay: String {
        return setScores.joined(separator: ", ")
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

class MatchHistoryManager: ObservableObject {
    private let storageKey = "savedMatches"

    @Published var matches: [SavedMatch] = []

    init() {
        loadMatches()
    }

    func save(match: SavedMatch) {
        matches.insert(match, at: 0)
        persistMatches()
    }

    func delete(at offsets: IndexSet) {
        matches.remove(atOffsets: offsets)
        persistMatches()
    }

    func delete(id: UUID) {
        matches.removeAll { $0.id == id }
        persistMatches()
    }

    func clearAll() {
        matches.removeAll()
        persistMatches()
    }

    private func loadMatches() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            matches = try JSONDecoder().decode([SavedMatch].self, from: data)
        } catch {
            print("Failed to load matches: \(error)")
        }
    }

    private func persistMatches() {
        do {
            let data = try JSONEncoder().encode(matches)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save matches: \(error)")
        }
    }
}
