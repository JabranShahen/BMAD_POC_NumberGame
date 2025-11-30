# Story: Game Screen Layout Upgrade (Card Focus / Answer Grid / Palette Usage)

Epic: Epic 2 – Visual Identity & Interaction Flow  
Source: UI Modernization Review v2 (notes include current pixel overflow on avatar row)

## Intent
Improve readability and interaction clarity by centering the core puzzle in a focused card, presenting answers in a 2×2 grid, and applying the updated palette (Lynx White, Vanadyl Blue, Blueberry Soda, Skirret Green, Nasturcian Flower) to enhance comfort and game feel. Fix the top-row overflow while rebalancing spacing.

## Acceptance Criteria
1) Puzzle card: Centered Lynx White card with soft shadow and radius; sequence fits cleanly; missing number outlined in Vanadyl Blue.  
2) Answer layout: Replace vertical button stack with a 2×2 grid; options evenly sized; symmetric spacing.  
3) Palette use:  
   - Primary text: Mazarine Blue  
   - Hover/correct: Skirret Green  
   - Incorrect/negative: Nasturcian Flower  
   - Background can use gradient into Vanadyl Blue / Periwinkle; buttons/grid honor the palette.  
4) Tap feedback: Buttons animate on press with light scale and tint; correct flashes green briefly; incorrect pulses orange-red.  
5) Typography: Bold for numbers and puzzle title; medium weight for answers; legibility prioritized.  
6) Spacing & padding: Added breathing room around the puzzle card; answer grid spacing consistent; prevents crowding and resolves top-row overflow (avatar/chips).  

## QA Notes
- Puzzle card centered, readable, and visually prioritized.  
- Answers in 2×2 grid with consistent geometry and spacing.  
- Correct flash = Skirret Green; incorrect = Nasturcian Flower tint only.  
- Numbers/title contrast strongly on Lynx White.  
- Animations responsive, not exaggerated.  
- No overflow or collision in the HUD (chips/lives/avatar); layout scales on various screen sizes.  

## Review Notes
- Answer feedback currently pre-tints buttons based on correctness before selection (logic ties to `_puzzle!.answer == opt`). Needs state-driven tint only on user selection/result.
- Avatar looping on Gameplay was set to true; confirm desired behavior (play once per state or continuous idle).  
