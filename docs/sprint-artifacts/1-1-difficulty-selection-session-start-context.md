# Story Context: 1.1 Difficulty Selection & Session Start

Epic: Epic 1 - Core Gameplay Loop  
Source: docs/epics.md (Story 1.1)  
PRD FRs: FR-001, FR-003

Intent: Let players pick Fun/Medium/Hard, start a session with correct timer constants (8s/6s/4s). Back/exit returns home without starting.

Notes:
- UI: three difficulty cards/buttons showing timer hint and best score badge.
- Logic: set mode constants, seed puzzles; lock portrait.
- Edge: back out should not start a session.
