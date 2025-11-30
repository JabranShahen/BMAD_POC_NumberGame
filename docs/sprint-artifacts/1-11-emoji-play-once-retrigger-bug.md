# Bug: Gameplay avatar one-shot animation doesn’t re-trigger on state change

Epic: Epic 1 - Core Gameplay Loop  
Source: Post Story 1-10 observation  

## Summary
Gameplay avatar animations were set to play once (non-loop) to reduce distraction. However, when the emoji state changes (e.g., lives decrement), the animation does not replay; it stays on the last frame from the previous state.

## Expected vs Actual
- Expected: On each state change (lives, game over), the one-shot animation should replay once for the new state.
- Actual: Animation plays once and stays on its last frame, not replaying when the state changes.

## Acceptance Criteria
1) GameplayScreen: Avatar animation replays once per state change (e.g., lives change, game over), then idles. No continuous looping.
2) Difficulty/Game Over: Keep existing behavior (looping unless changed intentionally).
3) Reduce motion: Static emoji fallback remains for reduce-motion users.
4) flutter analyze passes.

## Suggested Implementation
- Give the Lottie widget a state-based key (e.g., `ValueKey('$key-${widget.lives}-${widget.gameOver}')`) so state changes rebuild the widget and replay the one-shot animation on Gameplay.

## QA Notes
- On Gameplay, change lives 5→4→3→2→1: each change should replay the animation once, then idle.
- Game over state should also play once when reached.
- Difficulty/Game Over screens retain their current looping behavior.
- Reduce-motion still shows static emoji.

## Review Notes
- Resolved: Key now excludes `remainingSeconds` and keys on lives/gameOver only, so animation replays on meaningful state changes without ticking every second.
