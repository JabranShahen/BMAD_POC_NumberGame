# Story Context: 3.1 Interstitials Between Sessions

Epic: Epic 3 - Ads and Offline Behavior  
Source: docs/epics.md (Story 3.1)  
PRD FRs: FR-013, FR-014

Intent: Show interstitial ads only between sessions; never during puzzles; fail-open if not ready in 2s.

Notes:
- Gate screen after game over; if ad not ready/failed/offline after 2s, start next session.
- Respect platform/age guidelines; test IDs in dev.
- Ads service wrapper to isolate SDK errors.
