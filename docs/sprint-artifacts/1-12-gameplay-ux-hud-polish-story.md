# Story: Gameplay HUD & CTA Polish

Epic: Epic 1 - Core Gameplay Loop  
Source: UX review (Gameplay screen imbalance)  

## Intent
Improve the Gameplay HUD balance and CTA clarity: align the top status bar, use palette-consistent chips, lighten the avatar presentation, soften answer buttons, and make “End run” a proper tertiary control.

## Acceptance Criteria
1) Status bar alignment: Timer, lives, and score appear in a single, aligned row with even spacing and consistent chip sizing. Avatar aligns opposite the row without crowding the content below; add a modest gutter before the puzzle card.  
2) Palette consistency: Timer/score chips use the Sunset Punch secondary (blue) with ~10–15% alpha backgrounds and matching text/icon color; remove off-palette pink/grey. Lives stay legible on the same row.  
3) Avatar presentation: Avatar shadow/lightweight framing matches card shadows (subtle), and its size remains consistent with hero/compact variants; no heavy halo.  
4) Answer buttons: Primary CTAs retain the orange brand but with softened weight (lighter fill or softer shadow) and clear hover/press states; spacing between buttons feels balanced.  
5) “End run” control: Present as a tertiary text/button with proper tap target and palette-consistent color (not tiny red text); placement is deliberate and discoverable.  
6) Responsiveness & animation: Gameplay animations still play once per state change (not per timer tick); avatar responsiveness to lives/game-over remains intact.  
7) Accessibility: Text/icon contrast meets AA on chips/buttons; tap targets ≥44px.

## QA Notes
- Top bar: aligned chips (timer/lives/score) + avatar; check spacing above puzzle card.  
- Chips: timer/score use blue palette with subtle alpha; no stray pink/grey.  
- Avatar: subtle shadow, consistent sizing.  
- Buttons: softened orange treatment with visible press/hover states; spacing even.  
- End run: tertiary control visible, tappable, palette-consistent.  
- Animation: avatar replays once per state change, not per second; reduce-motion still static.  
