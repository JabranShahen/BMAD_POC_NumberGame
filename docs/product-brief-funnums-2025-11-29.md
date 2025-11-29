# Product Brief: funnums

**Date:** 2025-11-29  
**Author:** Jabran  
**Context:** mobile game (missing-number puzzle)

---

## Executive Summary

funnums is a fast-paced numerical puzzle game where users identify a missing number from a sequence or group under time pressure. It is designed for casual gameplay with short sessions, reward loops, and skill progression across three difficulty tiers. The game aims to improve cognitive agility, pattern recognition, and mental mathematics while maintaining a fun, light-weight, and repeatable play experience.

---

## Core Vision

### Problem Statement

Most brain-training puzzle games either become too repetitive or too complex too quickly. Users need a mentally stimulating but approachable number-puzzle experience that is quick to play, satisfying, and progressively challenging.

### Problem Impact

Current number-puzzle experiences fail to:
- strike a balance between speed and cognitive challenge
- provide incremental difficulty that rewards improvement
- track user performance history as meaningful progression
- keep sessions short and engaging without long commitment
- provide casual accessibility for younger audiences and adults alike

### Why Existing Solutions Fall Short

Existing numeric puzzle apps often:
- overwhelm users with complex math or large numbers
- use slow turn-based mechanics rather than continuous active puzzles
- provide minimal reward feedback loops
- lack persistent score tracking and motivational progression indicators

### Proposed Solution

funnums offers:
- quick-turn puzzles with immediate feedback
- animated visual cues for urgency & excitement
- scoring, record-keeping, and solved counters for continual motivation
- difficulty levels tuned for different player skill tiers
- multi-platform accessibility and lightweight performance
- no ads in current scope; focus on core loop quality

### Key Differentiators

- Time-pressure format that encourages instinctive reasoning  
- Difficulty curves that adjust total answer time per puzzle  
- Satisfaction feedback through sounds and animations  
- Persistent score history & best-score achievements  
- Non-frustrating UI: simple, clean, and child-friendly  

---

## Target Users

### Primary Users

- Casual mobile gamers age 9+
- Players who enjoy pattern recognition and IQ-style games
- Adults who enjoy short mental challenges during idle time
- Students who want to sharpen analytic reasoning

### Secondary Users

- Parents seeking educational gameplay for children
- Educators recommending cognitive-training apps
- Individuals looking for light brain-exercise routines

### User Journey

1. User opens app  
2. Sees score history and statistics  
3. Selects difficulty level  
4. Plays a sequence of fast-paced puzzles  
5. Receives visual and sound feedback for correct/incorrect answers  
6. Runs out of lives or completes session  
7. Receives “Game Over” summary  
8. Optionally restarts immediately  

---

## Success Metrics

### Business Objectives

- Achieve a growing active player base through virality and session replay  
- Encourage short but frequent engagement sessions  
- Build UX foundation for future multiplayer and tournament features  

### Key Performance Indicators

- Daily Active Users (DAU)  
- Average Session Time  
- Average Sessions Per User (ASPU)  
- Player Retention after day 1 / day 7 / day 30  
-   
- Puzzle completion rate per difficulty level  

---

## MVP Scope

### Core Features

- Random puzzle generation from curated datasets  
- Three difficulty modes: Fun, Medium, Hard  
- Time-based challenge system  
- Life system (5 mistakes allowed)  
- Score & historical record storage  
- Sound on/off feature  
- “Solved count” by difficulty  
- Animated feedback for correct / wrong answers  
-   

### Out of Scope for MVP

- Cloud-synced user accounts  
- Multiplayer or leaderboard  
- Character avatars or cosmetic customization  
- In-app purchase functionality  
- Social-sharing mechanics  

### MVP Success Criteria

- Stable release with <1% crash rate  
- Players reliably understand core gameplay within 1 minute  
- At least 60% of users complete one full game session  
- At least 25% of users play a second session in the same week  

### Future Vision

- Live global leaderboards  
- Daily puzzle challenges  
- Reward badges and achievement systems  
- Optional offline mode  
- Adaptive puzzles that learn user difficulty tolerance  
- Teacher / parent dashboard for educational analytics  

---

## Market Context

The casual puzzle market is large and evergreen. The concept aligns within:  
- brain-training games  
- minimal UI casual games  
- short-session mobile experiences  

Top competitors overlap with:
- Lumosity  
- Elevate  
- Sudoku apps  
- Number puzzle casual games  

funnums differentiates through short-burst numerical puzzles with motivational progression and instant-response gameplay.

---

## Financial Considerations

- Monetization deferred; no ads in current scope.  
- Future options (when/if reintroduced): premium puzzle packs or paid tiers; avoid intrusive ads.  

---

## Technical Preferences

- Flutter for cross-platform deployment  
- Provider state management (existing)  
- Local storage using JSON file persistence  
- Lightweight audio asset usage  
- Offline-capable puzzle logic  

---

## Organizational Context

Developed as an independent project by Jabran.  
Project structure enables collaboration with additional designers or developers if needed.

---

## Risks and Assumptions

- Risk: Puzzle logic must not become predictable or repetitive  
- Assumption: Users will replay multiple short sessions  
- Assumption: Existing device-based score persistence is acceptable for MVP  
- Assumption: Performance must remain smooth on low-spec devices  

---

## Timeline

- MVP Prototype: Completed  
- Polish & refinement: 2–3 weeks  
- App Store / Google Play publication: 4 weeks target  
- Post-launch: track feedback and iterate monthly  

---

## Supporting Materials

- Current working app codebase  
- User experience animations and sound assets  
- Test puzzle datasets (easy, medium, hard)  

---

_This Product Brief captures the vision and requirements for funnums._  
_It was created through collaborative discovery and reflects the unique needs of this mobile game (missing-number puzzle) project._  
_Next: Use the PRD workflow to create detailed product requirements from this brief._  
