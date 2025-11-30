# Story: Control emoji avatar animation looping

Epic: Epic 1 - Core Gameplay Loop  
Source: Observed UX issue (avatars continuously looping animations)

## Intent
Prevent the emoji avatar from continuously looping its animation so it feels calmer and less distracting, while retaining visual feedback for state changes (lives, game over, difficulty welcome).

## Acceptance Criteria
1) Loop control: Avatar animations do not loop continuously; they play once or a short, non-distracting cycle, then idle. Apply consistently on Gameplay and Difficulty.
2) State fidelity: Faces still change correctly per state (difficulty welcome, lives 5→1, game over) using the existing assets/mapping.
3) Reduce-motion respect: When reduce-motion is true or system prefers reduced motion, fall back to the static emoji (already supported) with no animation.
4) Regression: Game over and lives-based expressions remain correct; size parity with Difficulty remains intact.

## QA Notes
- Verify on Gameplay: for each lives value (5→1) and game over, the animation plays once (or minimal cycles) and then idles; no continuous looping.
- Verify on Difficulty: welcome animation follows the same non-looping behavior.
- Check reduce-motion: with device reduce-motion enabled, static emoji is shown (no animation).
- Confirm no unintended flicker or performance regressions.  
