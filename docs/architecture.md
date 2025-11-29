# Architecture

## Executive Summary

funnums is a mobile, offline-friendly missing-number puzzle. Architecture is mobile-first (Flutter), local-first (Hive or JSON), and ships with no ads. Priorities: fast loop (8/6/4s timers), smooth 60fps UI, deterministic puzzle validation, and local persistence for scores/history/settings.

Project initialization: single Flutter app targeting Android/iOS, portrait-only, minimal dependencies (Provider for state, Hive/JSON storage).

## Decision Summary

| Category | Decision | Version | Affects Epics | Rationale |
| -------- | -------- | ------- | ------------- | --------- |
| Platform | Flutter (Android/iOS, portrait) | Flutter 3.16.5 / Dart 3.2.3 | All | Cross-platform, good perf on low-end devices |
| State Mgmt | Provider + ChangeNotifier | provider 6.1.1 | All | Simple, familiar, sufficient for small app |
| Storage | Hive (or JSON fallback) in app docs dir | hive 2.2.3 / hive_flutter 1.1.0 | Epics 2,3 | Local-first, fast, versionable |
| Timer/Loop | Per-mode constants (8s/6s/4s), urgency <3s | n/a | Epic 1 | Aligns FR-003 timing and UX cues |
| Puzzle Data | Curated per-difficulty pools; de-dup per session | n/a | Epic 2 | Avoid repeats; deterministic validation |
| Connectivity | Offline banner optional | connectivity_plus 5.0.2 | Epic 3 | Awareness without blocking gameplay |
| Analytics | None by default; optional later with consent | n/a | All | Privacy-first, no PII |
| Error/Logging | Non-PII logs; guard storage failures | n/a | All | Stability offline/low-spec |



## Project Structure

```
app/
  lib/
    main.dart
    core/        # theme, routing, services (storage, puzzles)
    features/
      gameplay/  # puzzle screen, timer, lives, feedback
      session/   # scoring, history, stats
      settings/  # sound/haptics toggles

    data/
      models/    # puzzle, session stats
      sources/   # local storage adapters
  assets/
    audio/
    puzzles/
```

## Epic to Architecture Mapping

- Epic 1 (Gameplay): gameplay module, timer service, puzzle renderer, feedback controller.
- Epic 2 (Scoring/History/Persistence): session module, storage adapter (Hive/JSON), history view.
- Epic 3 (Offline): connectivity observer/banner (optional).
- Epic 4 (Growth): placeholders for leaderboard/daily/badges entry points (hidden until enabled).

## Technology Stack Details
## Technology Stack Details

### Core Technologies

- Flutter 3.16.5 (stable), Dart 3.2.3
- State: Provider + ChangeNotifier
- Storage: Hive (preferred) or JSON file + path_provider
- Build: Flutter toolchain; Android/iOS targets
- Build: Flutter toolchain; Android/iOS targets

### Integration Points

- Connectivity plugin (optional) for offline banner


## Implementation Patterns

These patterns ensure consistent implementation across all AI agents:

- Single-source timer constants per difficulty; inject into gameplay loop.
- Services layer (storage, puzzles) injected into feature widgets.
- Fail-open wrappers around storage; never block gameplay.
- Deterministic puzzle validation; reject ambiguous puzzles at load time.

## Consistency Rules

### Naming Conventions

- Packages snake_case; classes PascalCase; methods/vars camelCase.
- Traceability comments: // FR-00X, Story N.M when relevant.

### Code Organization

- Features by domain (gameplay, session, settings).
- Core for theme, routing, shared services/interfaces.
- Data for models/adapters; avoid UI-storage coupling.

### Error Handling

- Guard storage reads; on corruption reset safely with defaults.
- Inline/toast feedback; no blocking modals mid-play.

### Logging Strategy

- Non-PII logs; debug in dev; suppress verbose in release.
- Log storage errors and puzzle validation rejections.

## Data Architecture

- Models: Puzzle (sequence, missing slot, options, answer, difficulty), SessionStats (score, bestPerMode, solvedCounts, history list), Settings (sound, haptics).
- Storage namespaces per difficulty; versioned schema for migration; validate puzzles on load to ensure single answer.

## API Contracts

- Local-only for MVP; no remote APIs. Future: leaderboard/daily endpoints when enabled.

## Security Architecture

- No accounts/PII; all data local. If analytics added, require consent and minimal events.

## Performance Considerations

- Target 60fps; puzzle render + transition <300ms.
- Cold start to play <=3s on mid/low devices.
- Timer urgency updates efficient; avoid expensive rebuilds.


## Deployment Architecture

- Mobile app store deployment (Android/iOS), portrait-only (lock in AndroidManifest/Info.plist).
- CI: flutter format --set-exit-if-changed; flutter analyze; flutter test; build release artifacts.

## Development Environment

### Prerequisites


- Flutter SDK stable (3.16.5), Android Studio/Xcode; Hive/JSON storage libs.
### Setup Commands

```bash
flutter create --platforms=android,ios funnums   # portrait lock in manifests
flutter pub get
flutter test
flutter run --flavor dev
```

## Architecture Decision Records (ADRs)

- Platform: Flutter over dual native.
- State: Provider over heavier blocs.
- Storage: Hive/local JSON over remote backend.
- Analytics: none by default; add only with consent later.
- Analytics: none by default; add only with consent later.

## Test/QA Checklist (lightweight)
- Performance: timer/loop updates under 300ms; cold start to play <=3s on mid/low devices; 60fps target during puzzles.
- Storage: corruption resets safely; local-only; persistence of scores/history/settings validated.
- Accessibility: labels for timer, lives, answers; focus order; contrast for feedback states; large tap targets.
- Offline: full gameplay works without network; optional banner only outside puzzles.



---

_Generated by BMAD Decision Architecture Workflow v1.0_  
_Date: 2025-11-29_  
_For: Jabran_

---

## Workflow Context (for traceability)

- Mode: CREATE (no existing architecture.md previously)
- Available Context: PRD (docs/prd.md), Epics (docs/epics.md), UX (docs/ux-design-specification.md), no domain/architecture docs

