# Technical Specification — funnums (quick spec)

**Mode:** Standalone quick spec (story count: 3, greenfield)  
**Context sources:** PRD (docs/prd.md), Epics (docs/epics.md), UX (docs/ux-design-specification.md), Architecture (docs/architecture.md)  
**Goal:** Capture definitive implementation guidance for the core gameplay loop, persistence/history, and fail-open ads.

---

## 1) Problem / Need
- Build a fast, offline-friendly missing-number puzzle loop with clear timers, lives, and immediate feedback.
- Persist scores/bests/history/settings locally; avoid repeat puzzles in short runs.
- Show interstitial ads only between sessions; fail-open within 2s; never block gameplay.

## 2) Solution Overview
- Flutter mobile app (portrait-only) with per-mode timers (8s/6s/4s), auto-advance on correct answers, urgency cues under 3s.
- Local-first storage via Hive (or JSON fallback) for scores/history/settings; puzzle pools per difficulty with de-dup window.
- AdMob interstitials via a gate screen between sessions; offline and ad-fail paths skip ads automatically.

## 3) Scope
- In scope: Gameplay loop, timers/lives/feedback, local persistence, history view, sound/haptics toggles, fail-open ads.  
- Out of scope: Accounts, cloud sync, leaderboards/daily/badges (placeholders only), multiplayer, in-app purchases.

## 4) Stack & Versions (pin for build)
- Flutter 3.16.5 (stable), Dart 3.2.3 (checked 2025-11-29)
- State: provider 6.1.1
- Storage: hive 2.2.3, hive_flutter 1.1.0, path_provider 2.1.1
- Ads: google_mobile_ads 3.0.0
- Connectivity: connectivity_plus 5.0.2 (optional banner)
- Tests: flutter_test (SDK), integration_test (SDK), mocktail 1.0.0
- Lints: flutter_lints 3.0.0

## 5) Source Tree / Files (create/modify)
```
app/lib/
  main.dart                             (wire DI/services/theme/routing; portrait lock)
  core/
    app_theme.dart                      (colors/typography aligned to UX spec)
    di.dart                             (register services: AdsService, StorageService, PuzzleService)
    routing.dart                        (home → difficulty → gameplay → game over)
    services/
      ads_service.dart                  (AdMob wrapper, 2s timeout, fail-open)
      storage_service.dart              (Hive init, boxes, JSON fallback guard)
      puzzle_service.dart               (load pools, serve puzzles, de-dup)
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
      settings_screen.dart              (sound/haptics toggles, about ads note)
    ads/
      interstitial_gate.dart            (between-session gate, ad load/skip UX)
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
- Ads: request interstitial after Game Over; if not ready in 2s or offline, proceed to next session; never during gameplay.
- Offline banner: optional; show only outside puzzles; no blocking dialogs.
- Routing: home/difficulty → gameplay → game over → gate → back to difficulty.
- Error/logging formats: log JSON lines with level, message, context {feature, mode, event, errorCode}; no PII. For storage/ad failures, log and continue (fail-open).
- State/event patterns: gameplay controller emits events (timerTick, answerCorrect, answerWrong, timerExpired, livesChanged, gameOver). Ads service emits adReady/adFailed; gate observes and times out at 2s.

## 7) Integration Points
- AdMob interstitials (google_mobile_ads) with test IDs in dev; real IDs via flavor/env.
- Connectivity_plus for offline banner (optional; feature flaggable).

## 8) Data Models (concrete)
- Puzzle: { id, difficulty, sequence: List<int>, missingIndex: int, options: List<int>, answer: int }
- SessionStats: { mode, score, bestPerMode: Map<mode,int>, solvedCounts: Map<mode,int>, history: List<HistoryEntry> }
- HistoryEntry: { mode, score, timestamp }
- Settings: { soundEnabled: bool, hapticsEnabled: bool, version: int }

## 9) Testing Strategy
- Unit: puzzle validation, timer logic, life decrement, storage read/write/reset, ads fail-open timeout.
- Widget: gameplay screen (timer display, urgency styling, auto-advance), game over summary, history list rendering, settings toggles persistence.
- Integration: end-to-end happy path per difficulty; ad gate flow with mocked ads service (fail and success).
- Accessibility: ensure labels for timer, lives, answers; focus order; contrast check.
- Coverage targets: unit + widget ≥ 80% combined; critical paths (timer, ads gate, storage reset) must be covered.

## 10) Acceptance Criteria (implementation-level)
- Timer per mode matches 8/6/4s; urgency styling under 3s; timer stops on answer.
- Lives decrement on wrong/timeout; game over at 0 with score/best/solved summary.
- Correct answers auto-advance without extra taps.
- Sound/haptics toggles persist across restarts; defaults on first run set to on.
- History shows last N scores per difficulty; best score updates; solved counts increment per correct.
- Ad gate: no ads during puzzles; between-session only; if ad not ready within 2s or offline, next session starts without blocking.
- Offline mode: gameplay works fully; no blocking dialogs; optional banner only outside puzzles.
- Storage corruption handled without crash; defaults restored.

## 11) Development Setup
```bash
flutter create --platforms=android,ios funnums   # portrait lock in AndroidManifest/Info.plist
flutter pub get
flutter test
flutter run --flavor dev
```
Ensure AdMob test IDs in dev flavor; real IDs only in release with consented config.

## 12) Deployment / CI
- Target Android/iOS, portrait-only (lock orientation in AndroidManifest and Info.plist).
- CI: flutter format --set-exit-if-changed; flutter analyze; flutter test; build per platform. Fail build on test failures. Lint via flutter_lints.

## 13) Stories (for this quick spec, 3)
1) Gameplay loop & timers/lives/feedback: implement gameplay_screen/controller, timer constants, urgency cues, auto-advance, game over summary.  
2) Persistence & history: storage init, repositories, history screen, best/solved counts, settings toggles persistence, corruption reset.  
3) Ads & offline: ads service with 2s fail-open gate, between-session overlay, offline banner optional, wiring into flow after game over.

---

_Created for quick technical guidance; aligns with PRD, Epics, UX, and Architecture for funnums._

Note: Canonical stories live in `docs/epics.md` (Method track). This quick spec does not generate new story files.
