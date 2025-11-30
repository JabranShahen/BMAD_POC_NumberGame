# Story: Gameplay HUD Micro-Polish (Alignment/Palette/Button Weight)

Epic: Epic 1 - Core Gameplay Loop  
Source: UX review post 1-12

## Intent
Apply final micro-polish to the Gameplay HUD: clean alignment in the top row, ensure palette consistency on chips, lighten CTA weight, and refine avatar spacing so the UI feels balanced and less crowded.

## Acceptance Criteria
1) Status row alignment: Timer, hearts, score, and avatar sit on a single baseline with consistent heights. Add a small horizontal buffer so hearts/chips don’t crowd the avatar; avatar aligns cleanly to the right.  
2) Palette consistency: Timer/score chips use the secondary blue with subtle alpha; red is used only for urgent text/icon, not chip background. Chip sizes match each other.  
3) Hearts spacing: Even, minimal horizontal padding so the row reads as one unit without collisions.  
4) CTAs: Orange answer buttons are slightly lighter or softer (reduced visual weight); shadows/rounding are subtle; vertical spacing tightened so the stack feels less bulky.  
5) “End run”: Tertiary control is slightly more discoverable (size/weight bump) while staying secondary/tertiary in hierarchy.  
6) Avatar: Outer ring/shadow remains subtle; ensure it doesn’t overpower adjacent chips.

## QA Notes
- Check top bar: aligned baseline, matching chip heights, hearts/chips not crowding avatar.  
- Timer chip: blue with alpha; urgent uses red text/icon only.  
- Buttons: lighter/softer orange with clear press state; spacing tightened.  
- End run: visible and tappable with slight emphasis.  
- Avatar: balanced shadow/halo vs chips.
