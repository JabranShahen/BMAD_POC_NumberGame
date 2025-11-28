# Story: 1-4-continuous-puzzle-flow

## Story

As a player,
I want a new puzzle to appear automatically after I answer or time runs out,
So that the gameplay feels continuous and I can stay in flow without extra interactions.

## Acceptance Criteria

**Given** I select the correct answer  
**When** feedback is shown  
**Then** a new puzzle loads automatically after 0.5–1 second  

**Given** the puzzle time expires  
**When** feedback indicates timeout  
**Then** a new puzzle loads automatically after 0.5–1 second  

**Given** puzzles exist in JSON  
**When** the next puzzle is selected  
**Then** the system retrieves a random puzzle of matching difficulty  

**Given** the app is running  
**When** a new puzzle loads  
**Then** the timer resets to full duration  

## Prerequisites

Story 1.1  
Story 1.2  
Story 1.3

## Technical Notes

- Implement `PuzzleRepository` to load puzzles from `assets/puzzles.json`
- Add `_startNewPuzzle()` method in `GameScreen`
- Move puzzle creation logic out of `_createSamplePuzzle`
- Use `Future.delayed` (700–1000ms) after feedback before loading next
- Ensure difficulty filter applied: `puzzle.difficulty == _currentDifficulty`
- Clear `_timerExpired` and `_resultText` on puzzle reset

## Tasks / Subtasks

- [x] Create `assets/puzzles.json` with minimum 20 puzzles
- [x] Implement `PuzzleRepository` with:
  - [x] JSON loading
  - [x] random puzzle retrieval
  - [x] optional difficulty filtering
- [x] Replace `_createSamplePuzzle` usage
- [x] Implement `_startNewPuzzle()` in GameScreen
- [x] Trigger new puzzle after:
  - [x] correct answer
  - [x] timer expiry

## Dev Notes

- Implemented PuzzleRepository with JSON loading from assets/puzzles.json
- Added puzzle caching and random selection with difficulty filtering
- Modified GameScreen to use repository instead of hardcoded sample puzzles
- Added _startNewPuzzle() method with proper state reset (timer, animation controller, result text, timeout flags)
- Implemented automatic puzzle transitions after 800ms delay on both correct answers and timeout
- Ensured timer resets to full duration on new puzzle load
- Added fallback to sample puzzle if JSON loading fails

## Dev Agent Record

### Debug Log

(To be filled automatically by BMAD agents)

### Completion Notes

(To be filled after ACs are validated)

## File List

- `lib/features/game/data/models/puzzle_model.dart` - New file containing PuzzleRepository and JSON model
- `lib/main.dart` - Modified to use repository and automatic puzzle transitions
- `assets/puzzles.json` - JSON puzzle data (pre-existing)

## Change Log

- Created PuzzleRepository class with JSON loading and random puzzle retrieval
- Added PuzzleModel for JSON deserialization
- Modified GameScreen to use repository instead of sample puzzles
- Implemented _startNewPuzzle() method with proper state management
- Added automatic puzzle transitions after 800ms delay for both answer selections and timeouts
- Ensured proper cleanup and reset of timer, animation controller, and UI state

## Status

planned

## Senior Developer Review (AI)

### Reviewer

(To be assigned)

### Date

(To be assigned)

### Outcome

(To be assigned)
