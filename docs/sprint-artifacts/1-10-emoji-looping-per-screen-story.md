# Story: Control emoji animation looping per screen

Epic: Epic 1 - Core Gameplay Loop  
Source: UX request (only stop looping on Gameplay; keep looping elsewhere)

## Intent
Scope animation looping behavior so that Gameplay avatars do not repeat, while Difficulty and Game Over can continue looping as before. Preserve state fidelity and reduce-motion fallback.

## Acceptance Criteria
1) Gameplay: Avatar animations do not loop continuously (play once or minimal) on GameplayScreen.  
2) Difficulty & Game Over: Avatar animations retain looping behavior (or current desired behavior) on those screens.  
3) State fidelity: Lives/difficulty/game-over expressions remain correct; size parity unchanged.  
4) Reduce motion: Existing reduce-motion static emoji fallback remains intact.

## Implementation Notes
- Likely add an explicit `loop`/`playOnce` prop to `EmojiAvatarWidget` (default to existing looping), set to non-loop on GameplayScreen only.

## QA Notes
- Gameplay: each state animation should not loop; settles after initial play.  
- Difficulty/Game Over: animations loop as before.  
- Reduce-motion: still shows static emoji.  
