# Bug: Lives5 animation not matching calm/confident intent

Epic: Epic 1 - Core Gameplay Loop  
Source: Post-Story 1.7 review (Architect)  

## Summary
The refined emotion curve requires a calm/confident face at 5 lives (🙂). Current implementation maps `lives5` to the grinning/laughing-style animation, which reads more excited than intended.

## Affected Code
- `funnums/lib/features/gameplay/widgets/emoji_avatar.dart`  
  - `_assetMap['lives5']` → `assets/animated_emoji/-grinning-.json`

## Expected vs Actual
- Expected: 5 lives uses a calm/confident animation matching the 🙂 tone (e.g., `-smile-.json`).
- Actual: 5 lives uses a grinning/laughing animation (`-grinning-.json`), which is higher energy.

## Acceptance Criteria
1) Update the lives5 animation to a calm/confident asset (e.g., `assets/animated_emoji/-smile-.json`) consistent with the Story 1.7 emotion curve (🙂 at 5 lives).
2) Verify gameplay avatar at 5 lives displays the calm animation; other lives remain unchanged.
3) `flutter analyze` passes after the change.

## QA Notes
- Launch gameplay, set lives=5: avatar animation should be the calm/smile variant (no grinning/laughing).
- Transition lives 5→4→3→2→1 to ensure other states unaffected.
- Timer should not influence the face.
