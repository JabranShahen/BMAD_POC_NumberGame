# Technical Specification — funnums (quick spec)

**Mode:** Standalone quick spec (story count: 3, greenfield)  
**Context sources:** PRD (docs/prd.md), Epics (docs/epics.md), UX (docs/ux-design-specification.md), Architecture (docs/architecture.md)  
**Goal:** Capture definitive implementation guidance for the core gameplay loop and persistence/history (no ads in scope).

---

## UX Handoff Notes (for SM/Dev)
- 2025-11-30 (with Jabran): Ready for story — Gameplay layout realign to centered stack. Use AC1–AC5 in the “UX change spec — Gameplay layout update” section below. Status/state is tracked in docs/sprint-artifacts/sprint-status.yaml.
- 2025-11-30: Story drafted at docs/sprint-artifacts/1-15-gameplay-layout-realign.md; sprint-status updated to drafted.

## 1) Problem / Need
- Build a fast, offline-friendly missing-number puzzle loop with clear timers, lives, and immediate feedback.
- Persist scores/bests/history/settings locally; avoid repeat puzzles in short runs.

## 2) Solution Overview
- Flutter mobile app (portrait-only) with per-mode timers (8s/6s/4s), auto-advance on correct answers, urgency cues under 3s.
- Local-first storage via Hive (or JSON fallback) for scores/history/settings; puzzle pools per difficulty with de-dup window.

## 3) Scope
- In scope: Gameplay loop, timers/lives/feedback, local persistence, history view, sound/haptics toggles.  
- Out of scope: Accounts, cloud sync, leaderboards/daily/badges (placeholders only), multiplayer, in-app purchases.

## 4) Stack & Versions (pin for build)
- Flutter 3.16.5 (stable), Dart 3.2.3 (checked 2025-11-29)
- State: provider 6.1.1
- Storage: hive 2.2.3, hive_flutter 1.1.0, path_provider 2.1.1
- Connectivity: connectivity_plus 5.0.2 (optional banner)
- Tests: flutter_test (SDK), integration_test (SDK), mocktail 1.0.0
- Lints: flutter_lints 3.0.0

## 5) Source Tree / Files (create/modify)
```
app/lib/
  main.dart                             (wire DI/services/theme/routing; portrait lock)
  core/
    app_theme.dart                      (colors/typography aligned to UX spec)
    di.dart                             (register services: StorageService, PuzzleService)
    routing.dart                        (home -> difficulty -> gameplay -> game over)
    services/
      storage_service.dart              (Hive init, boxes, JSON fallback guard)
      puzzle_service.dart               (load pools, serve puzzles, de-dup)
      connectivity_service.dart         (optional banner state)
      connectivity_service.dart         (optional banner state)
  data/
    models/
      puzzle.dart                       (sequence, missingIndex, options, answer, difficulty)
      session_stats.dart                (score, bestPerMode, solvedCounts, history entries)
      settings.dart                     (sound, haptics)
    sources/
      puzzle_repository.dart            (load puzzle pools per difficulty, validate unique answers)
      session_repository.dart           (persist stats/history; versioned schema)
      settings_repository.dart          (persist toggles)
  features/
    gameplay/
      gameplay_screen.dart              (puzzle UI, timer, lives, feedback)
      gameplay_controller.dart          (state machine, timers, lives, scoring hooks)
    session/
      history_screen.dart               (last N scores per difficulty, best/solved)
    settings/
      settings_screen.dart              (sound/haptics toggles)


  assets/
    audio/                              (correct/wrong sounds)
    puzzles/                            (per-difficulty pools, e.g., json)
```

## 6) Technical Approach (definitive)
- Timers: constants per mode (fun=8s, medium=6s, hard=4s). Urgency style under 3s. Use Ticker/Timer per puzzle; cancel on dispose.
- Lives: start 5; decrement on wrong/timeout; game over at 0 → summary screen.
- Auto-advance: on correct, immediately fetch next puzzle; no extra tap.
- Feedback: visual flash (green/red), text cue; optional sound/haptics tied to toggles.
- Storage: initialize Hive boxes at app start; on corruption, reset with defaults. Namespace per difficulty for scores/history/solved.
- History: store last N (e.g., 10) session scores per difficulty; include timestamp.
- Puzzle validation: ensure single correct answer per entry; reject ambiguous puzzles at load; simple de-dup window in a session.
- Offline banner: optional; show only outside puzzles; no blocking dialogs.
- Routing: home/difficulty -> gameplay -> game over -> back to difficulty.
- Error/logging formats: log JSON lines with level, message, context {feature, mode, event, errorCode}; no PII. For storage failures, log and continue (fail-open).
- State/event patterns: gameplay controller emits events (timerTick, answerCorrect, answerWrong, timerExpired, livesChanged, gameOver).

## 7) Integration Points
- Connectivity_plus for offline banner (optional; feature flaggable).

- Connectivity_plus for offline banner (optional; feature flaggable).

## 8) Data Models (concrete)
- Puzzle: { id, difficulty, sequence: List<int>, missingIndex: int, options: List<int>, answer: int }
- SessionStats: { mode, score, bestPerMode: Map<mode,int>, solvedCounts: Map<mode,int>, history: List<HistoryEntry> }
- HistoryEntry: { mode, score, timestamp }
- Settings: { soundEnabled: bool, hapticsEnabled: bool, version: int }

## 9) Testing Strategy
- Unit: puzzle validation, timer logic, life decrement, storage read/write/reset.
- Widget: gameplay screen (timer display, urgency styling, auto-advance), game over summary, history list rendering, settings toggles persistence.
- Integration: end-to-end happy path per difficulty; storage/persistence flows.
- Accessibility: ensure labels for timer, lives, answers; focus order; contrast check.
- Coverage targets: unit + widget >= 80% combined; critical paths (timer, storage reset) must be covered.

## 10) Acceptance Criteria (implementation-level)
- Timer per mode matches 8/6/4s; urgency styling under 3s; timer stops on answer.
- Lives decrement on wrong/timeout; game over at 0 with score/best/solved summary.
- Correct answers auto-advance without extra taps.
- Sound/haptics toggles persist across restarts; defaults on first run set to on.
- History shows last N scores per difficulty; best score updates; solved counts increment per correct.
- Offline mode: gameplay works fully; no blocking dialogs; optional banner only outside puzzles.
- Storage corruption handled without crash; defaults restored.

## 11) Development Setup

```bash
flutter create --platforms=android,ios funnums   # portrait lock in AndroidManifest/Info.plist
flutter pub get
flutter test
flutter run --flavor dev
```


## 12) Deployment / CI
- Target Android/iOS, portrait-only (lock orientation in AndroidManifest and Info.plist).
- CI: flutter format --set-exit-if-changed; flutter analyze; flutter test; build per platform. Fail build on test failures. Lint via flutter_lints.

## 13) Stories (for this quick spec)
1) Gameplay loop & timers/lives/feedback: implement gameplay_screen/controller, timer constants, urgency cues, auto-advance, game over summary.  
2) Persistence & history: storage init, repositories, history screen, best/solved counts, settings toggles persistence, corruption reset.  
3) Offline awareness (optional): connectivity service and banner, ensure gameplay unaffected without network.  
4) Gameplay layout realign to centered stack (UX): restack gameplay_screen to match the reference layout (puzzle card → avatar → timer/hearts/score row → prompt → answers grid; End run bottom-right).

## 14) UX change spec — Gameplay layout update
**Goal:** Align gameplay_screen layout to the provided reference while keeping existing palette/components.

**Target layout (top to bottom, centered column within maxWidth=520):**
- Puzzle card: centered pill with light shadow, single row of sequence blocks, missing slot highlighted.
- Emoji avatar: centered directly beneath puzzle card, use existing EmojiAvatarWidget hero sizing.
- Status row: centered row containing timer chip (left), hearts (middle, 5 slots), score chip (right); slightly larger heart icons than current.
- Prompt: “Find the missing number” label left-aligned within the column.
- Answers: 2x2 grid, same rounding/palette and sizing as current; no horizontal scroll on small portrait devices.
- End run link: aligned bottom-right of the content column.

**Acceptance criteria (layout):**
- AC1: Puzzle card is centered above the avatar; avatar is centered above the status row.
- AC2: Status row centers timer chip (left), hearts (middle), score chip (right); hearts remain 5 slots and visibly larger than current 22px icons.
- AC3: Prompt and 2x2 answers remain below, within the maxWidth column, using existing button styles/colors.
- AC4: “End run” link sits at the bottom-right of the content column.
- AC5: Layout fits small portrait screens without horizontal scroll; spacing consistent with reference (single column, generous vertical padding).

**QA notes:**
- Verify on small portrait (e.g., iPhone SE/Pixel 4a) and a larger device.
- Check timer urgency state visibility, hearts decrement, score updates, and avatar renders.
- Ensure safe-area padding and no overlap with system bars; scroll still works when content exceeds viewport.

**Dependencies/Risks:** None; visual regression risk on tablets—spot-check on a larger simulator.

---

_Created for quick technical guidance; aligns with PRD, Epics, UX, and Architecture for funnums._

Note: Canonical stories live in `docs/epics.md` (Method track). This quick spec does not generate new story files.
