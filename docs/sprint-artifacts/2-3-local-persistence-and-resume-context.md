# Story Context: 2.3 Local Persistence and Resume

Epic: Epic 2 - Scoring, History, and Persistence  
Source: docs/epics.md (Story 2.3)  
PRD FRs: FR-015, FR-016, FR-018

Intent: Persist toggles/settings and handle interruptions safely (restore or clean end) without crashes.

Notes:
- Decide strategy: restore in-progress session or cleanly end; keep consistent.
- Defensive JSON/Hive parsing; versioned schema; reset on corruption.
- Settings toggles persist; app relaunch loads saved state.
