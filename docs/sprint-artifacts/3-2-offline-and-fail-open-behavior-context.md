# Story Context: 3.2 Offline and Fail-Open Behavior

Epic: Epic 3 - Ads and Offline Behavior  
Source: docs/epics.md (Story 3.2)  
PRD FRs: FR-014

Intent: Keep gameplay fully offline; skip ads when offline/fail; optional offline banner outside puzzles.

Notes:
- No blocking dialogs; sessions start immediately when offline.
- Ad calls fail-open with backoff; log failures, don’t crash.
- Optional connectivity banner outside puzzles; hide during active play.
