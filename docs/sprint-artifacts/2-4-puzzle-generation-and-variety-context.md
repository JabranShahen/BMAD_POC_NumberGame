# Story Context: 2.4 Puzzle Generation and Variety

Epic: Epic 2 - Scoring, History, and Persistence  
Source: docs/epics.md (Story 2.4)  
PRD FRs: FR-017

Intent: Serve varied puzzles per difficulty, avoid repeats in short runs, ensure single unambiguous answer, keep generation performant.

Notes:
- Maintain per-mode pools/seeds; de-dup window per session.
- Validate puzzles on load; reject ambiguous entries.
- Keep generation + transition under 300ms.
