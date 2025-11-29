# funnums UX Design Specification

_Created on 2025-11-29 by Jabran_  
_Generated using BMad Method - Create UX Design Workflow v1.0_

---

## Executive Summary

funnums is a mobile missing-number puzzle built for fast, repeatable sessions. The UX centers on a frictionless loop: pick a difficulty, race a visible timer, see instant feedback, and loop back through a simple Game Over summary with non-intrusive, between-session ads. Clarity (timer, lives, score), speed (auto-advance), and calm visuals keep players focused while subtle reward cues (sound/animation) reinforce progress.

---

## 1. Design System Foundation

### 1.1 Design System Choice

Hybrid native-first approach: follow iOS HIG and Material patterns for controls and navigation, with light custom styling (friendly colors, bold numeric typography) for game identity. Keep components minimal to prioritize clarity and speed; reuse platform defaults for dialogs, toasts, and lists to reduce risk and improve accessibility.

---

## 2. Core User Experience

### 2.1 Defining Experience

Defining loop: choose difficulty -> solve a missing-number puzzle under a visible timer -> get immediate feedback -> continue until lives expire -> view Game Over summary (score, best, solved) -> restart. Success hinges on instant comprehension (numbers legible, timer clear) and zero friction between puzzles (auto-advance on correct).

### 2.2 Novel UX Patterns

None required; the loop fits standard mobile game patterns (timer, lives, score, summary). Focus on polish: readable numerals, urgent yet calm timer cues, non-blocking ads between sessions.

---

## 3. Visual Foundation

### 3.1 Color System (Sunset Punch palette)

- Primary CTA: Harley Davidson Orange #D14A28 (filled buttons, key CTAs)  
- Secondary / Ground: Seabrook #3F7BB9 with deep navy #1F2F55 for gradients/headers  
- Accent / Badges: Nanohanacha Gold #D6A21F (Best tags), neutral #F0F2F5 for “Last”  
- Surface / Background: Lynx White #F5F6F8; Cards white with soft shadow  
- Text: Electromagnetic #2B2F36 on light; white on dark/gradient headers  
- Error: #E44F4F (wrong answer, life loss)  
- Tone: bright, approachable; maintain AA contrast for all text/icon on fills.

**Interactive Visualizations:** Not generated in this pass.

---

## 4. Design Direction

### 4.1 Chosen Design Approach

Clean card-based layout with oversized numerals and prominent timer ring/bar. Portrait-only, single-column. Top bar: timer + lives + score. Middle: puzzle card with sequence and answer options. Bottom: discreet controls (sound/haptics toggle), minimal chrome. Feedback uses quick flashes and gentle haptics; avoid modal interruptions except Game Over. Ads only between sessions with a slim “Next round loading” gate. Difficulty screen uses Seabrook->deep navy gradient header, orange primary CTAs, and gold/neutral badges for Best/Last.

**Interactive Mockups:** Not generated in this pass.

---

## 5. User Journey Flows

### 5.1 Critical User Paths

**Journey: Start & Play (MVP)**  
1) Home: “Choose your challenge” + buttons Fun/Medium/Hard, show best and last score per mode.  
2) Difficulty: three cards with timer hints (Fun 8s, Medium 6s, Hard 4s) and best badges. Start launches puzzle.  
3) Puzzle: show sequence with missing slot, answer options, timer ring/bar, lives (5 hearts), score. Timer visible; expiry = mistake. Correct auto-advances; wrong animates and decrements lives.  
4) Game Over: summary (score, best, solved count), CTAs “Play again” and “Change difficulty.”  
5) Ads gate (between sessions): “Next round loading”; if ad fails/offline, skip gracefully.

**Journey: History & Progress (MVP)**  
1) Home -> History: list per difficulty with last N scores, best, solved count.  
2) Empty state: “Finish a run to see your progress.”  
3) Return CTA to play again.

**Journey: Settings & Controls (MVP)**  
1) Header/overflow: toggles for sound and haptics.  
2) Note: applies immediately; persists across sessions.  
3) Link: “About ads” (explains between-session only, fail-open offline).

**Journey: Offline / Ad Fail (MVP)**  
1) Detect offline: banner “Offline — puzzles still work. Ads skipped.”  
2) No blocking dialogs; play flow unchanged.  
3) When back online, ads resume between sessions.

---

## 6. Component Library

### 6.1 Component Strategy

Use native buttons, lists, modals. Custom/lightly styled components aligned to palette:  
- Puzzle Card: sequence layout with missing slot; responsive to varied number widths; missing cell tinted Seabrook 12% with feedback wash (primary tint on correct, red tint on wrong).  
- Timer Ring/Bar/Chip: primary tint base; urgency shift under 3s; chip uses subtle tint with high-contrast text.  
- Lives Indicator: 5 hearts; primary-colored active state; animates on loss.  
- Answer Options: large touch targets, filled primary buttons with white text; focus/press overlays.  
- Badges: “Best” gold (#D6A21F, white text); “Last” neutral (#F0F2F5, dark text).  
- Game Over Summary Card: white surface on Lynx White background; CTAs use primary filled and secondary outline.  
- Ads Gate Overlay: lightweight overlay with spinner/text; no modal blocks.

State considerations: default, press/hover (where applicable), active, error/wrong, success, disabled (ads loading). Accessibility: visible focus rings on buttons, readable text labels on timers and feedback messages.

---

## 7. UX Pattern Decisions

### 7.1 Consistency Rules

- Buttons: Primary = filled orange (#D14A28) with white text + visible focus ring; Secondary = Seabrook outline with light fill on press; Destructive (rare) = error red.  
- Feedback: Success inline flash + optional toast; Error inline flash/red + brief toast; Loading = spinner in overlays only.  
- Forms/Inputs: Labels above; inline validation on submit or error; concise helper text.  
- Modals: Avoid during play; Game Over as full-screen sheet; ads gate as lightweight overlay.  
- Navigation: Single-stack portrait flow; back from difficulty to Home; in-run back disabled to prevent accidental exits.  
- Empty states: Friendly icon + single CTA.  
- Confirmation: Only for exiting mid-session (if enabled) or resetting data.  
- Notifications: Toast bottom for non-blocking info; short duration; screen-reader friendly text.  
- Date/time: Use relative timers with explicit seconds remaining.

---

## 8. Responsive Design & Accessibility

### 8.1 Responsive Strategy

Primary: mobile portrait.  
- Mobile: single column; bottom padding for safe areas; large tap targets (48dp).  
- Tablet: centered column with generous margins; larger puzzle card; optional split for history/details.  
- Desktop (optional): centered fixed-width column; same hierarchy.

Accessibility (target WCAG 2.1 AA):  
- Contrast: meet AA for text/icons; timer/lives states distinguishable by shape + color.  
- Keyboard/focus support for accessibility modes; visible focus rings.  
- Screen reader labels: timer, lives count, “x lives left,” “correct/wrong,” “time’s up,” “ad loading/skipped.”  
- Touch targets: >=48dp; avoid tightly packed answers.

---

## 9. Implementation Guidance

### 9.1 Completion Summary

- Core loops defined: start -> timed puzzle -> feedback -> summary -> restart with between-session ads.  
- Components: puzzle card, timer, lives, answer grid, summary card, ads gate, toggles.  
- Patterns: primary/secondary buttons, inline feedback, non-blocking overlays, AA contrast, large tap targets.  
- Offline/fail-open: ads never block play; clear banner when offline.  
- References: PRD/epics aligned; future hooks (leaderboard/daily/badges) remain hidden placeholders.

---

## Appendix

### Related Documents

- Product Requirements: `docs/prd.md`
- Product Brief: `docs/product-brief-funnums-2025-11-29.md`
- Brainstorming: n/a

### Core Interactive Deliverables

- Color Theme Visualizer: not generated in this pass.
- Design Direction Mockups: not generated in this pass.

### Optional Enhancement Deliverables

_None added in this pass._

### Next Steps & Follow-Up Workflows

- Wireframe Generation (or Excalidraw) for key screens.  
- Interactive prototype if desired.  
- Component showcase to lock states/variants.  
- Feed UX context into architecture and build.

### Version History

| Date       | Version | Changes                                              | Author |
| ---------- | ------- | ---------------------------------------------------- | ------ |
| 2025-11-29 | 1.0     | Initial UX Design Specification                      | Jabran |
| 2025-11-29 | 1.1     | Updated to Sunset Punch palette and component states | Jabran |

---

_This UX Design Specification was created through collaborative design facilitation. Decisions emphasize speed, clarity, and non-intrusive monetization for funnums’ timed number-puzzle experience._
