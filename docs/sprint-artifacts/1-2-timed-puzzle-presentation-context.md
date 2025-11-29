# Story Context: 1.2 Timed Puzzle Presentation

Epic: Epic 1 - Core Gameplay Loop  
Source: docs/epics.md (Story 1.2)  
PRD FRs: FR-002, FR-003, FR-004, FR-005

Intent: Render puzzle with missing slot, visible timer; auto-advance on correct; timeout counts as mistake.

Notes:
- Timer urgency under 3s (color/animation); cancel on dispose.
- Single unambiguous answer; show options/input clearly.
- On timeout: decrement lives, move next or game over.
