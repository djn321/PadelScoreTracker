# Padel Score Tracker - Product Spec

## Overview
A standalone Apple Watch app for tracking scores during Padel matches.

## Target Platform
- watchOS (standalone app, no iPhone companion required)
- Built with SwiftUI

## Core Features (v1.0)
- Track points using tennis-style scoring (0, 15, 30, 40, deuce, advantage)
- Track games (first to 6, win by 2)
- Track sets (best of 3)
- Simple tap interface to add points for each team
- Reset functionality to start a new match

## Core Features (v1.1)
- Match history - automatically saves completed matches
- History view showing date, final score, and set scores
- Swipe to delete old matches
- Data persists between app sessions

## Out of Scope (for now)
- Serve tracking
- Undo button
- Timer
- iPhone companion app

## UI Design

### Layout Concept
```
┌─────────────────┐
│  Sets: 1 - 0    │
│  Games: 4 - 3   │
│  Points: 30-15  │
├────────┬────────┤
│   Us   │  Them  │
│  (tap) │  (tap) │
└────────┴────────┘
```

### Interaction
- Tap left side: add point for "Us"
- Tap right side: add point for "Them"
- Reset button: start new match (with confirmation)

## Technical Architecture

### Components
1. **MatchModel** - data structure tracking:
   - Points for each team (0, 15, 30, 40, or deuce/advantage state)
   - Games for each team (per set)
   - Sets for each team
   - Match completion state

2. **MatchHistoryModel** - handles match persistence:
   - SavedMatch struct (Codable) with date, scores, win/loss
   - MatchHistoryManager for saving/loading via UserDefaults
   - Automatic save when match completes

3. **ScoringLogic** - handles:
   - Point progression (0→15→30→40→game)
   - Deuce and advantage rules
   - Game completion (first to 6, win by 2, tiebreak at 6-6)
   - Set completion
   - Match completion (best of 3 sets)

4. **ContentView** - main UI:
   - Score display
   - Tap zones for scoring
   - Reset button

## Scoring Rules Reference

### Points
- Sequence: 0 → 15 → 30 → 40 → Game
- At 40-40: Deuce
- After deuce: Advantage to scoring team
- If team with advantage scores: Game
- If team without advantage scores: Back to deuce

### Games
- First to 6 games wins the set
- Must win by 2 games
- At 6-6: Tiebreak (first to 7 points, win by 2)

### Sets
- Best of 3 sets
- First team to win 2 sets wins the match

---
*Created: 2025-01-14*
