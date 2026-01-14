import SwiftUI
import Combine

enum PointScore: String {
    case zero = "0"
    case fifteen = "15"
    case thirty = "30"
    case forty = "40"
    case advantage = "AD"
}

enum GameState {
    case normal
    case deuce
    case advantageUs
    case advantageThem
}

class MatchModel: ObservableObject {
    // Points
    @Published var usPoints: PointScore = .zero
    @Published var themPoints: PointScore = .zero
    @Published var gameState: GameState = .normal

    // Games (per set)
    @Published var usGames: [Int] = [0, 0, 0]
    @Published var themGames: [Int] = [0, 0, 0]

    // Sets
    @Published var usSets: Int = 0
    @Published var themSets: Int = 0

    // Current set index (0, 1, or 2)
    @Published var currentSet: Int = 0

    // Tiebreak state
    @Published var isTiebreak: Bool = false
    @Published var usTiebreakPoints: Int = 0
    @Published var themTiebreakPoints: Int = 0

    // Match state
    @Published var matchOver: Bool = false
    @Published var usWon: Bool = false

    // Callback when match ends
    var onMatchComplete: ((SavedMatch) -> Void)?

    // MARK: - Scoring

    func scorePointUs() {
        if matchOver { return }

        if isTiebreak {
            scoreTiebreakPoint(forUs: true)
            return
        }

        switch gameState {
        case .normal:
            scoreNormalPoint(forUs: true)
        case .deuce:
            gameState = .advantageUs
        case .advantageUs:
            winGame(forUs: true)
        case .advantageThem:
            gameState = .deuce
        }
    }

    func scorePointThem() {
        if matchOver { return }

        if isTiebreak {
            scoreTiebreakPoint(forUs: false)
            return
        }

        switch gameState {
        case .normal:
            scoreNormalPoint(forUs: false)
        case .deuce:
            gameState = .advantageThem
        case .advantageThem:
            winGame(forUs: false)
        case .advantageUs:
            gameState = .deuce
        }
    }

    private func scoreNormalPoint(forUs: Bool) {
        if forUs {
            switch usPoints {
            case .zero:
                usPoints = .fifteen
            case .fifteen:
                usPoints = .thirty
            case .thirty:
                usPoints = .forty
            case .forty:
                if themPoints == .forty {
                    gameState = .deuce
                    gameState = .advantageUs
                } else {
                    winGame(forUs: true)
                }
            case .advantage:
                break
            }
        } else {
            switch themPoints {
            case .zero:
                themPoints = .fifteen
            case .fifteen:
                themPoints = .thirty
            case .thirty:
                themPoints = .forty
            case .forty:
                if usPoints == .forty {
                    gameState = .deuce
                    gameState = .advantageThem
                } else {
                    winGame(forUs: false)
                }
            case .advantage:
                break
            }
        }
    }

    private func scoreTiebreakPoint(forUs: Bool) {
        if forUs {
            usTiebreakPoints += 1
        } else {
            themTiebreakPoints += 1
        }

        // Check for tiebreak win (first to 7, win by 2)
        let usTP = usTiebreakPoints
        let themTP = themTiebreakPoints

        if usTP >= 7 && usTP - themTP >= 2 {
            winSet(forUs: true)
        } else if themTP >= 7 && themTP - usTP >= 2 {
            winSet(forUs: false)
        }
    }

    private func winGame(forUs: Bool) {
        if forUs {
            usGames[currentSet] += 1
        } else {
            themGames[currentSet] += 1
        }

        // Reset points
        resetPoints()

        // Check for set win
        let usG = usGames[currentSet]
        let themG = themGames[currentSet]

        // Check for tiebreak
        if usG == 6 && themG == 6 {
            isTiebreak = true
            return
        }

        // Check for set win (first to 6, win by 2)
        if usG >= 6 && usG - themG >= 2 {
            winSet(forUs: true)
        } else if themG >= 6 && themG - usG >= 2 {
            winSet(forUs: false)
        }
    }

    private func winSet(forUs: Bool) {
        if forUs {
            usSets += 1
        } else {
            themSets += 1
        }

        // Reset tiebreak state
        isTiebreak = false
        usTiebreakPoints = 0
        themTiebreakPoints = 0

        // Check for match win (best of 3)
        if usSets == 2 {
            matchOver = true
            usWon = true
            onMatchComplete?(createSavedMatch())
            return
        } else if themSets == 2 {
            matchOver = true
            usWon = false
            onMatchComplete?(createSavedMatch())
            return
        }

        // Move to next set
        currentSet += 1
        resetPoints()
    }

    private func resetPoints() {
        usPoints = .zero
        themPoints = .zero
        gameState = .normal
    }

    // MARK: - Display Helpers

    var pointsDisplay: String {
        if isTiebreak {
            return "\(usTiebreakPoints) - \(themTiebreakPoints)"
        }

        switch gameState {
        case .normal:
            return "\(usPoints.rawValue) - \(themPoints.rawValue)"
        case .deuce:
            return "Deuce"
        case .advantageUs:
            return "AD - 40"
        case .advantageThem:
            return "40 - AD"
        }
    }

    var gamesDisplay: String {
        return "\(usGames[currentSet]) - \(themGames[currentSet])"
    }

    var setsDisplay: String {
        return "\(usSets) - \(themSets)"
    }

    var statusText: String {
        if matchOver {
            return usWon ? "We Won!" : "They Won"
        }
        if isTiebreak {
            return "Tiebreak"
        }
        return "Set \(currentSet + 1)"
    }

    // MARK: - Match Export

    func createSavedMatch() -> SavedMatch {
        var setScores: [String] = []

        // Include completed sets
        let completedSets = usSets + themSets
        for i in 0..<completedSets {
            setScores.append("\(usGames[i])-\(themGames[i])")
        }

        // Include current set if any games have been played
        if usGames[currentSet] > 0 || themGames[currentSet] > 0 {
            setScores.append("\(usGames[currentSet])-\(themGames[currentSet])")
        }

        // Determine winner for incomplete matches
        let didWeWin: Bool
        if matchOver {
            didWeWin = usWon
        } else if usSets != themSets {
            didWeWin = usSets > themSets
        } else {
            didWeWin = usGames[currentSet] > themGames[currentSet]
        }

        return SavedMatch(
            id: UUID(),
            date: Date(),
            usSets: usSets,
            themSets: themSets,
            setScores: setScores,
            usWon: didWeWin
        )
    }

    // MARK: - Reset

    func resetMatch() {
        usPoints = .zero
        themPoints = .zero
        gameState = .normal
        usGames = [0, 0, 0]
        themGames = [0, 0, 0]
        usSets = 0
        themSets = 0
        currentSet = 0
        isTiebreak = false
        usTiebreakPoints = 0
        themTiebreakPoints = 0
        matchOver = false
        usWon = false
    }
}
