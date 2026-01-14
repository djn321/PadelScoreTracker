# Padel Score Tracker

A standalone Apple Watch app for tracking scores during padel matches.

## Features

- **Tennis-style scoring** - Points (0, 15, 30, 40), deuce, and advantage
- **Full match tracking** - Games, sets (best of 3), and tiebreaks
- **Simple tap interface** - Tap left for "Us", right for "Them"
- **Match history** - Automatically saves completed matches with date and scores
- **End game early** - Save incomplete matches when you run out of time
- **Swipe navigation** - Main scoring screen + options page

## Screenshots

The app has two screens:

**Main Screen** - Score display and tap zones for scoring points

**Options Screen** (swipe left) - End Game, History, and Reset buttons

## How to Use

1. Start the app - you're ready to track a new match
2. Tap "Us" or "Them" to add points to each team
3. The app handles all scoring rules automatically (deuce, tiebreaks, etc.)
4. Swipe left for options:
   - **End Game** - Save current match and start fresh
   - **History** - View past matches
   - **Reset** - Clear current match without saving
5. When a match completes naturally (2 sets won), it saves automatically

## Scoring Rules

### Points
- Sequence: 0 → 15 → 30 → 40 → Game
- At 40-40: Deuce
- After deuce: Advantage → Game (or back to deuce)

### Games
- First to 6 games wins the set (must win by 2)
- At 6-6: Tiebreak (first to 7 points, win by 2)

### Sets
- Best of 3 sets
- First team to win 2 sets wins the match

## Requirements

- watchOS 10.0+
- Xcode 15.0+

## Installation

1. Clone this repository
2. Open `Padel Tracker/Padel Tracker.xcodeproj` in Xcode
3. Select your Apple Watch as the target device
4. Build and run

## Project Structure

```
PadelScoreTracker/
├── Padel Tracker/
│   └── Padel Tracker Watch App/
│       ├── ContentView.swift      # UI views (Score, Options, History)
│       ├── MatchModel.swift       # Scoring logic and match state
│       ├── MatchHistoryModel.swift # Persistence and saved matches
│       └── Padel_TrackerApp.swift # App entry point
├── ProductSpec.md                 # Feature specification
├── Release_Notes.md               # Version history
└── README.md
```

## Licence

MIT
