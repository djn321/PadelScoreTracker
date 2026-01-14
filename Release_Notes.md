# Padel Score Tracker - Release Notes

## v1.2 - 2026-01-14

### New Features
- **End Game Button**: End a match early and save to history (for when you run out of time)
- **Swipeable Options Page**: Swipe left to access options (End Game, History, Reset)
- **Cleaner Main Screen**: Removed buttons from main scoring view for less clutter

### Improvements
- Incomplete matches now save the current set score in progress
- Winner determination for incomplete matches based on sets won (or games if tied)

### Technical Changes
- Refactored `ContentView.swift` into separate views: `ScoreView`, `OptionsView`
- Added TabView with page style for swipeable navigation
- Updated `createSavedMatch()` to handle incomplete matches

---

## v1.1 - 2026-01-14

### New Features
- **Match History**: Completed matches are now automatically saved
- **History View**: Access past matches via the "History" button
  - Shows win/loss status
  - Displays final set score (e.g. "2-1")
  - Shows individual set scores (e.g. "6-4, 3-6, 6-2")
  - Includes date and time of match
- **Delete Matches**: Swipe left on any match in history to delete it
- **Persistent Storage**: Match history persists between app sessions using UserDefaults

### Technical Changes
- Added `MatchHistoryModel.swift` with `SavedMatch` struct and `MatchHistoryManager` class
- Updated `MatchModel.swift` with callback for match completion
- Updated `ContentView.swift` with navigation to `HistoryView`

---

## v1.0 - 2025-01-14

### Initial Release
- Track points using tennis-style scoring (0, 15, 30, 40, deuce, advantage)
- Track games (first to 6, win by 2)
- Track sets (best of 3)
- Tiebreak support at 6-6
- Simple tap interface to add points for each team
- Reset functionality with confirmation dialog
