# Story Context: 2.1 Scoring and Bests

Epic: Epic 2 - Scoring, History, and Persistence  
Source: docs/epics.md (Story 2.1)  
PRD FRs: FR-006, FR-007, FR-018

Intent: Increment score per session; store/show best per difficulty on start and game over; persist locally across restarts.

Notes:
- Atomic writes to per-mode bests; surface on home/difficulty and summary.
- Pull data via storage service; handle missing/corrupt data gracefully.
