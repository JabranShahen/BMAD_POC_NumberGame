# Story: Gameplay Avatar Parity and Refined Emotion Curve

Epic: Epic 1 - Core Gameplay Loop  
Source: User request (post Story 1.6)  

## Intent
Align the Gameplay avatar with Difficulty by using the hero size, and simplify the avatar expression so it is driven only by lives, using the refined emotion curve provided.

## Acceptance Criteria
1) Size parity: GameplayScreen avatar renders at the same hero size/dimensions as the DifficultyScreen avatar.  
2) Lives-only driver: On GameplayScreen, the avatar face is determined solely by remaining lives; timer/remainingSeconds does not alter the face.  
3) Refined emotion curve:  
   - 5 lives → 🙂 (calm, confident)  
   - 4 lives → 😊 (soft smile, doing fine)  
   - 3 lives → 😕 (concerned / unsure)  
   - 2 lives → 😰 (worried / stressed)  
   - 1 life → 😱 (fear / panic)  
   - 0 lives or gameOver=true → 😵 (dizzy / game-over)  
4) Regression: DifficultyScreen stays unchanged (hero size and welcome/default face). Game over still shows the game-over face.

## QA Notes
- Compare avatar size on Difficulty vs Gameplay; they should match visually.  
- Vary lives 5→0 in Gameplay; confirm faces follow the curve above.  
- Let timer drop to ≤3 seconds; face must stay on the lives-based expression (no timer-driven panic).  
- Verify game-over still shows 😵 when lives hit 0 or gameOver=true.  

## Review Findings (Architect)
- Observation: In `lib/features/gameplay/widgets/emoji_avatar.dart`, lives5 uses `assets/animated_emoji/-laughing-.json`. Story 1.7 calls for a calm/confident face at 5 lives (🙂). Action needed: swap lives5 asset to a calm animation (e.g., `-grinning-.json` or `-smile-.json`) to align animation with the refined curve. No code change applied; defer to the developer for fix.  
