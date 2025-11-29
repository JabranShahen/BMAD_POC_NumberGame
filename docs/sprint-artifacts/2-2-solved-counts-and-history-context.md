# Story Context: 2.2 Solved Counts and History

Epic: Epic 2 - Scoring, History, and Persistence  
Source: docs/epics.md (Story 2.2)  
PRD FRs: FR-008, FR-009, FR-018

Intent: Track solved count per difficulty and last N session scores; persist across restarts.

Notes:
- Decide N (e.g., 10). Include timestamps. Simple list per difficulty.
- Update solved counts on each correct answer; read/write via storage with versioning.
