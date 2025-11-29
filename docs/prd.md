# funnums - Product Requirements Document

**Author:** Jabran
**Date:** 2025-11-29
**Version:** 1.0

---

## Executive Summary

funnums is a casual mobile number-puzzle game where players spot the missing number in a series under time pressure. It targets short, repeatable play sessions with three difficulty tiers, motivating progression via scores, history, and "solved" counters. It balances quick cognitive challenge with lightweight, friendly UX to avoid player fatigue.

### What Makes This Special

- Time-pressure format for instinctive reasoning and rapid decision-making  
- Difficulty curves tuned per mode with strict answer windows  
- Motivational feedback (sound/animation) and persistent history/achievements  
- Minimal, non-intrusive ads between sessions only

---

## Project Classification

**Technical Type:** mobile_app (casual puzzle game)  
**Domain:** general (casual gaming)  
**Complexity:** low

Product type: mobile puzzle app focused on fast-turn numeric challenges. Domain risks are minimal; no regulated data. We're treating this as a general mobile product (not using the separate game-design module) to produce a PRD for requirements handoff.

### Domain Context

Casual, non-regulated; primary concerns are playability, performance on low-end devices, and clean ad placement.

---

## Success Criteria

Desired outcomes center on sticky short sessions, replay, and clarity of challenge across difficulty tiers:
- Players understand gameplay in under 1 minute
- High completion rate of at least one session per install
- Meaningful progression signals (scores, bests, solved counts)
- Ads placed only between sessions to avoid UX friction

### Business Metrics

- Daily Active Users (DAU)  
- Average Session Time  
- Average Sessions Per User (ASPU)  
- Player retention (D1/D7/D30)  
- Ad impressions per active user  
- Puzzle completion rate per difficulty level

---

## Product Scope

### MVP - Minimum Viable Product

- Random puzzle generation from curated datasets  
- Three difficulty modes: Fun, Medium, Hard (tuned answer timers per mode)  
- Time-based challenge system with countdown/urgency cues  
- Life system (5 mistakes allowed per session)  
- Score & historical record storage per mode  
- “Solved count” by difficulty and best-score tracking  
- Sound on/off toggle  
- Animated feedback for correct / wrong answers  
- Minimal interstitial ads only between game sessions

### Growth Features (Post-MVP)

- Live global leaderboards  
- Daily puzzle challenges  
- Reward badges and achievement systems  
- Optional offline mode without ads  
- Adaptive puzzles that learn user difficulty tolerance  
- Teacher/parent dashboard for educational analytics

### Vision (Future)

- Multiplayer/async tournaments  
- Seasonal puzzle packs and special events  
- Cosmetic themes and accessibility skins  
- Deeper analytics for educators/parents

---

## Domain-Specific Requirements

N/A (treated as general/casual; no regulated or high-risk domain constraints).

---

## Innovation & Novel Patterns

- Blend of cognitive “missing number” gameplay with fast response windows and lightweight session loops.

### Validation Approach

- Early playtests for comprehension within first minute  
- Measure puzzle completion rates and repeat sessions; tune timers/difficulty curves accordingly.

---

## mobile_app Specific Requirements

Mobile requirements (from product type signals):
- Platform requirements: Android/iOS support; performant on low-end devices; portrait orientation; responsive layouts for phones/tablets.
- Device capabilities: lightweight audio; haptics optional; no invasive permissions.
- Offline mode: puzzle logic works offline; scores stored locally; ad delivery handled gracefully when offline (fallback to no-ad).
- Push strategy: optional future use for streaks/challenges; not in MVP.
- Store compliance: adhere to Google Play / App Store guidelines; age-appropriate content; ad placements compliant with policies.

### Platform Support

- Target Android and iOS; portrait-first; adaptive UI for common mobile resolutions; minimal asset weight for quick installs.

### Device Capabilities

- Light audio effects; optional haptics; no contacts/location/storage permissions beyond local file storage for scores/state.

---

## Functional Requirements

### Capability Groups and FR List

**Gameplay Core**
- FR-001 [MVP]: Players can start a session by selecting a difficulty (Fun, Medium, Hard).
- FR-002 [MVP]: The system presents a missing-number puzzle per turn with clear options/inputs.
- FR-003 [MVP]: Each puzzle enforces a time limit tuned per difficulty; expiration counts as a mistake. Targets: Fun >= 8s, Medium 6s, Hard 4s; configurable constants.
- FR-004 [MVP]: Players have 5 lives per session; each wrong/missed answer reduces lives; game ends at 0.
- FR-005 [MVP]: Correct answers immediately advance to the next puzzle without extra taps.

**Scoring & Progression**
- FR-006 [MVP]: The system tracks and displays score per session (incrementing on correct answers).
- FR-007 [MVP]: The system stores best score per difficulty and shows it at session start.
- FR-008 [MVP]: The system increments "solved count" per difficulty for every correct answer.
- FR-009 [MVP]: Players can view simple history: last N session scores per difficulty.

**Feedback & UX**
- FR-010 [MVP]: The app provides instant visual feedback (correct/wrong) per answer.
- FR-011 [MVP]: The app provides optional audio feedback; players can toggle sound on/off.
- FR-012 [MVP]: The game-over screen summarizes score, best score, solved count, and play-again CTA.

**Ads & Monetization**
- FR-013 [MVP]: Interstitial ads appear only between sessions (never mid-puzzle).
- FR-014 [MVP]: If offline or an ad fails to load, the session proceeds without blocking gameplay. Ad load/fail timeout must not exceed 2 seconds before starting play.

**Settings & Device Behavior**
- FR-015 [MVP]: Players can toggle sound and (if available) haptics in settings or inline control.
- FR-016 [MVP]: The app preserves state locally so users can resume after app interruption (same session or clean restart per chosen approach). If session restore is not supported, app must end the session cleanly and preserve prior records/settings.

**Content & Data**
- FR-017 [MVP]: Puzzle generation uses curated datasets per difficulty to avoid repeats in short runs.
- FR-018 [MVP]: All game state (scores, solved counts, bests, settings) is stored locally on device.

### User Stories with Acceptance Criteria

1) Difficulty selection  
As a player, I want to choose a difficulty so I can play at my skill level.  
Acceptance: a) Three options visible; b) Selecting a mode starts session; c) Timer and puzzles reflect chosen mode.

2) Timed puzzles with lives  
As a player, I want timed puzzles with limited lives so the game feels challenging.  
Acceptance: a) Timer shown each puzzle; b) Expired timer counts as mistake; c) Five total lives; d) Game over at 0 lives.

3) Scoring and history  
As a player, I want my scores and bests tracked so I can see progress.  
Acceptance: a) Score increments on correct answers; b) Best score per difficulty stored and shown; c) Session history shows recent scores; d) Solved count increments per correct answer.

4) Feedback and controls  
As a player, I want instant feedback and control over sound so the game feels responsive.  
Acceptance: a) Correct/wrong visual cues shown immediately; b) Optional sounds tied to events; c) Sound toggle persists across sessions.

5) Ads between sessions only  
As a player, I want ads to appear only between sessions so gameplay is not interrupted.  
Acceptance: a) No ads during puzzles or timers; b) Interstitial only after session end and before next start; c) If ad fails or offline, session can start without blocking.

6) Persistence  
As a player, I want my scores and settings saved locally so I don't lose progress.  
Acceptance: a) Scores/bests/solved counts stored on device; b) Settings (sound/haptics) persist; c) App relaunch preserves saved data.

---

## Non-Functional Requirements

### Performance
- App cold start to playable state in <= 3s on mid/low-tier devices.
- Steady 60fps target during puzzles; no dropped frames on common devices.
- Puzzle generation and transition under 300ms.

### Security & Privacy
- No personal accounts; no collection of PII.
- All game data stored locally; no external transmission for MVP.
- If analytics added later, require explicit consent and minimal event capture.

### Accessibility & UX Quality
- High-contrast color palette with clear correct/wrong cues.
- Sound/haptics optional; must be toggled off by user if desired.
- Large touch targets and readable number typography for small screens.

### Availability / Offline
- Core gameplay fully offline; no dependency on network for puzzles or scores.
- Ads are best-effort; lack of network must not block new sessions.

### Compatibility
- Android and iOS current + 2 OS versions; portrait-first layouts; handle notch/safe areas.

### Integration
- Ad network: interstitial placements only between sessions; fail-open behavior.

### Maintainability & Quality
- Deterministic puzzle validation (no ambiguous answers).
- Logging limited to non-PII events for debugging; disable verbose logs in production.

---

## PRD Summary
- FR count: 18 across gameplay core, scoring/progression, feedback/UX, ads, settings/persistence, and content/data.
- NFR coverage: performance (with timer targets), security/privacy, accessibility/UX quality, offline/availability, compatibility, integration (ads), maintainability.
- MVP scope: timed missing-number puzzles with three difficulty tiers, lives, score/best/solved history, visual/audio feedback, between-session ads only.

## Product Value Summary
- Quick, repeatable cognitive challenge with low friction and clear progression signals.
- Respectful monetization (interstitials only between sessions) to preserve flow.
- Offline-friendly gameplay with lightweight assets for broad device reach.

---

## References
- Product brief: docs/product-brief-funnums-2025-11-29.md

---

_This PRD captures the essence of funnums - mobile number-puzzle gameplay with time-pressure, progression, and lightweight monetization._

_Created through collaborative discovery between Jabran and AI facilitator._
