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

### Story 1.5 - Difficulty Button Color Theming (MVP)
- User Story: As a player, I want each difficulty button to look distinct so I can quickly pick my mode.
- Acceptance Criteria (BDD):
  - Given the difficulty screen loads, when buttons render, then Fun is Seabrook (#3F7BB9) with white text/icons.
  - Given the difficulty screen loads, when buttons render, then Medium is Harley Orange (#D14A28) with white text/icons.
  - Given the difficulty screen loads, when buttons render, then Hard is Deep Navy (#1F2F55) with white text/icons and retains gold/neutral badges.
  - Given focus/press states, when they occur, then buttons darken ~8–10% and show a gold (#D6A21F) focus ring while keeping AA contrast.
- Prerequisites: Story 1.1.
- Technical Notes: Align with Sunset Punch palette; ensure badges remain legible on chosen fills; safe tap targets ≥48dp.

## FR Coverage Matrix
- FR-001: Epic 1 Story 1.1
- FR-002: Epic 1 Story 1.2
- FR-003: Epic 1 Story 1.1, 1.2
- FR-004: Epic 1 Story 1.2, 1.3
- FR-005: Epic 1 Story 1.2
- FR-010: Epic 1 Story 1.4
- FR-011: Epic 1 Story 1.4
- FR-012: Epic 1 Story 1.3
- FR-015: Epic 1 Story 1.4

## Epic Breakdown Summary
- Epics: 1 (Core Gameplay)
- Stories: 4 total (MVP-focused)
- UX alignment: Timer urgency, auto-advance, large touch targets, immediate feedback
- NFR highlights: Timer targets (8s/6s/4s)

---

## Traceability Summary
- Epic 1: FR-001, FR-002, FR-003, FR-004, FR-005, FR-010, FR-011, FR-012
