# funnums - Epics and Stories

## Epic 1 - Core Gameplay Loop (MVP)
- Goal: Deliver a playable timed missing-number loop with lives and immediate feedback.
- FR Coverage: FR-001, FR-002, FR-003, FR-004, FR-005, FR-010, FR-011, FR-012

### Story 1.1 - Difficulty Selection & Session Start (MVP)
- User Story: As a player, I want to choose a difficulty (Fun/Medium/Hard) so I can play at my skill level.
- Acceptance Criteria (BDD):
  - Given the home screen is loaded, when I tap Fun/Medium/Hard, then a session starts in that mode (FR-001).
  - Given I select a mode, when the session starts, then timers use that mode’s targets (Fun 8s, Medium 6s, Hard 4s) (FR-003).
  - Given I change my mind, when I back out, then I return to home without starting a session.
- Prerequisites: None.
- Technical Notes: Mode selection sets timer constants and difficulty seed; align with UX layout (three cards, best score badge).

### Story 1.2 - Timed Puzzle Presentation (MVP)
- User Story: As a player, I want each puzzle to show clearly with a visible timer so I can answer before time runs out.
- Acceptance Criteria (BDD):
  - Given a puzzle is shown, when it renders, then I see the sequence with one missing slot and clear answer options/input (FR-002).
  - Given the timer is running, when it expires, then I lose one life and move to the next puzzle or Game Over if lives are 0 (FR-003, FR-004).
  - Given I answer correctly before time expires, when I submit, then I advance automatically without extra taps (FR-005).
  - Given the timer is below 3 seconds, when time declines, then the timer style shifts to urgency (color/animation).
- Prerequisites: Story 1.1.
- Technical Notes: Timer ring/bar with per-mode constants; ensure accessibility labels for timer and options; auto-advance on correct.

### Story 1.3 - Lives and Game Over (MVP)
- User Story: As a player, I want a clear lives system so I know when the session ends.
- Acceptance Criteria (BDD):
  - Given a session starts, when play begins, then I see 5 lives and each wrong/expired answer reduces lives by 1 (FR-004).
  - Given lives reach 0, when the last life is lost, then I see Game Over with score, best for mode, solved count, and Play Again / Change Difficulty (FR-012).
  - Given Game Over is shown, when I tap Play Again, then I return to difficulty selection and a fresh session starts.
- Prerequisites: Stories 1.1, 1.2.
- Technical Notes: Animate heart loss; ensure summary pulls from scoring data; avoid modal blocks mid-play (only at Game Over).

### Story 1.4 - Feedback & Controls (MVP)
- User Story: As a player, I want immediate feedback and control over audio so I can tune the experience.
- Acceptance Criteria (BDD):
  - Given I answer, when correct or wrong, then I get instant visual feedback (green/red flash, text cue) (FR-010).
  - Given sound is on, when events occur, then matching sounds play; when I toggle sound off, then sounds stop and the setting persists (FR-011, FR-015).
  - Given haptics are available, when events occur, then haptics follow the toggle; devices without haptics do not error (FR-015).
- Prerequisites: Story 1.2.
- Technical Notes: Use unified feedback component; store sound/haptics toggles locally; provide accessible text equivalents.

## Epic 2 - Scoring, History, and Persistence (MVP)
- Goal: Track progress across sessions and preserve state locally.
- FR Coverage: FR-006, FR-007, FR-008, FR-009, FR-016, FR-017, FR-018

### Story 2.1 - Scoring and Bests (MVP)
- User Story: As a player, I want scores and bests per difficulty so I can see progress.
- Acceptance Criteria (BDD):
  - Given a session starts, when I answer correctly, then score increments and resets per session start (FR-006).
  - Given scores persist, when I finish a session, then best score per difficulty updates and shows on Home/Difficulty and Game Over (FR-007).
  - Given I relaunch the app, when it loads, then best scores are retrieved from local storage (FR-018).
- Prerequisites: Epic 1 stories complete.
- Technical Notes: Store per-mode bests; ensure atomic writes; surface in header cards.

### Story 2.2 - Solved Counts and History (MVP)
- User Story: As a player, I want solved counts and a short history to track improvement.
- Acceptance Criteria (BDD):
  - Given I answer correctly, when the session records progress, then solved count increments per difficulty (FR-008).
  - Given history exists, when I open History, then I see last N session scores and solved counts per mode (FR-009).
  - Given I relaunch, when data loads, then history and solved counts remain intact (FR-018).
- Prerequisites: Story 2.1.
- Technical Notes: Choose N (e.g., last 10); simple list with timestamps; guard against corrupted entries.

### Story 2.3 - Local Persistence and Resume (MVP)
- User Story: As a player, I want the app to handle interruptions without losing my settings and records.
- Acceptance Criteria (BDD):
  - Given I set sound/haptics, when I restart the app, then toggles persist (FR-015, FR-018).
  - Given the app is backgrounded/killed mid-session, when I return, then the app either restores the in-progress session state or ends cleanly and preserves scores/history (FR-016).
  - Given data corruption is detected, when loading, then the app safely resets invalid data without crashing (FR-018).
- Prerequisites: Story 2.1.
- Technical Notes: Decide strategy (restore vs clean end) and keep consistent; use defensive JSON parsing; add versioning to stored data.

### Story 2.4 - Puzzle Generation and Variety (MVP)
- User Story: As a player, I want varied puzzles per difficulty so runs feel fresh.
- Acceptance Criteria (BDD):
  - Given a session is running, when new puzzles are generated, then difficulty-appropriate datasets are used and recent repeats are avoided in short runs (FR-017).
  - Given a puzzle is presented, when answers are evaluated, then there is a single unambiguous correct answer.
  - Given generation occurs, when performance is measured, then puzzle creation and transition take under 300ms (aligning with PRD performance target).
- Prerequisites: Story 1.2.
- Technical Notes: Maintain per-mode pools or seeds; simple de-duplication window; log invalid puzzles for QA.

## Epic 3 - Ads and Offline Behavior (MVP)
- Goal: Monetize between sessions without disrupting gameplay; handle offline gracefully.
- FR Coverage: FR-013, FR-014

### Story 3.1 - Interstitials Between Sessions (MVP)
- User Story: As a player, I want ads only between sessions so gameplay is never interrupted.
- Acceptance Criteria (BDD):
  - Given I am playing, when puzzles are active, then no ads are shown; only after Game Over and before next start (FR-013).
  - Given an ad request is made, when it fails or is skipped, then the next session starts without blocking (FR-014).
  - Given policies apply, when an ad is shown, then placement follows platform guidelines and age-appropriate settings.
- Prerequisites: Epic 1 complete.
- Technical Notes: Insert lightweight gate screen; ensure navigation cannot trigger ad mid-play; respect 2s ad load/fail timeout from PRD.

### Story 3.2 - Offline and Fail-Open Behavior (MVP)
- User Story: As a player, I want the game to work offline without ad blocks.
- Acceptance Criteria (BDD):
  - Given I am offline, when I start or restart a session, then gameplay begins immediately with no blocking dialogs (FR-014).
  - Given ad calls fail, when a new session is starting, then ad requests are skipped or retried later without impacting play (FR-014).
  - Given network state changes, when playing, then session flow remains intact; show a small offline/online banner only outside puzzles.
- Prerequisites: Story 3.1.
- Technical Notes: Implement fail-open; backoff for ad retries; guard against ad SDK crashes; log failures for telemetry.

## Epic 4 - Growth & Future Hooks (Post-MVP)
- Goal: Prepare for post-MVP growth features.
- FR Coverage: future (Growth/Visions) for leaderboards, challenges, badges; keep placeholders tied to vision features.

### Story 4.1 - Leaderboard Hook (Growth)
- User Story: As a player, I want to compete on leaderboards so I can compare scores. (Future)
- Acceptance Criteria (placeholder):
  - Given best scores exist, when backend is available, then scores can be tagged and submitted via defined contract.
  - Given UI exists, when feature is inactive, then the entry point is hidden or disabled.
  - Given data model is defined, when syncing, then mode and score metadata are included.

### Story 4.2 - Daily Challenge Hook (Growth)
- User Story: As a player, I want daily challenges to drive repeat play. (Future)
- Acceptance Criteria (placeholder):
  - Given a daily seed, when the day changes, then a new daily puzzle is flagged and tracked.
  - Given completion is stored, when I finish the daily, then it cannot repeat until the next day.
  - Given UI is inactive, when not enabled, then the entry point is hidden/disabled.

### Story 4.3 - Achievements/Badges Hook (Growth)
- User Story: As a player, I want badges for milestones. (Future)
- Acceptance Criteria (placeholder):
  - Given badge rules exist, when milestones fire (e.g., solved counts, streaks), then they are evaluated locally.
  - Given evaluation runs, when a badge is earned, then it can be stored locally and displayed when UI is enabled.
  - Given UI is inactive, when not enabled, then badge display is hidden/disabled.

---

## FR Coverage Matrix
- FR-001: Epic 1 Story 1.1
- FR-002: Epic 1 Story 1.2
- FR-003: Epic 1 Story 1.1, 1.2
- FR-004: Epic 1 Story 1.2, 1.3
- FR-005: Epic 1 Story 1.2
- FR-006: Epic 2 Story 2.1
- FR-007: Epic 2 Story 2.1
- FR-008: Epic 2 Story 2.2
- FR-009: Epic 2 Story 2.2
- FR-010: Epic 1 Story 1.4
- FR-011: Epic 1 Story 1.4
- FR-012: Epic 1 Story 1.3
- FR-013: Epic 3 Story 3.1
- FR-014: Epic 3 Story 3.1, 3.2
- FR-015: Epic 1 Story 1.4; Epic 2 Story 2.3
- FR-016: Epic 2 Story 2.3
- FR-017: Epic 2 Story 2.4
- FR-018: Epic 2 Stories 2.1, 2.2, 2.3

## Epic Breakdown Summary
- Epics: 4 (Core Gameplay, Scoring/History/Persistence, Ads/Offline, Growth Hooks)
- Stories: 13 total (MVP-focused plus future hooks)
- UX alignment: Timer urgency, auto-advance, non-blocking ads, offline banners, large touch targets
- NFR highlights: Timer targets (8s/6s/4s), ad load/fail timeout <= 2s, local persistence with defensive loading

---

## Traceability Summary
- Epic 1: FR-001, FR-002, FR-003, FR-004, FR-005, FR-010, FR-011, FR-012
- Epic 2: FR-006, FR-007, FR-008, FR-009, FR-015, FR-016, FR-017, FR-018
- Epic 3: FR-013, FR-014
- Epic 4 (future hooks): Growth/vision items (leaderboards, daily challenges, achievements) to be mapped when activated.
