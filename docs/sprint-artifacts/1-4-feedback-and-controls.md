# Story 1.4: Feedback and Controls

Status: drafted

## Story

As a player, I want instant visual feedback and control over audio/haptics so I can tune the experience and immediately know if my answer was correct or wrong.

## Requirements Context

- Epic 1.4 (Epics: docs/epics.md): Feedback & Controls for timed puzzles; immediate visual cue on answer result; audio/haptics tied to user toggle; devices without haptics must not error.
- PRD (docs/prd.md): FR-010 visual feedback per answer; FR-011 sound toggle; FR-015 haptics optional, must respect toggle and not crash on unsupported devices.
- Architecture (docs/architecture.md): Mobile/portrait Flutter; keep loop performant; optional haptics/audio must fail-open; non-blocking UI during gameplay.

## Acceptance Criteria

1. Given I answer, when correct or wrong, then I see instant visual feedback (green/red flash and/or text cue) without blocking the next puzzle (FR-010).
2. Given sound is on, when events occur, then matching sounds play; when I toggle sound off, then sounds stop and the setting persists across app restarts (FR-011, FR-015).
3. Given haptics are available, when events occur, then haptics follow the toggle; devices without haptics do not error and continue gameplay normally (FR-015).

## Tasks / Subtasks

- [ ] Implement visual feedback for answer result (AC1)
  - [ ] Ensure feedback shows immediately on answer and clears before next puzzle render
  - [ ] Verify no blocking modals; feedback coexists with timer updates
- [ ] Wire audio feedback to toggle (AC2)
  - [ ] Play success/fail sounds when enabled; silence when disabled
  - [ ] Persist sound setting via SettingsRepository; reload on app start
- [ ] Wire haptics to toggle with safe fallback (AC3)
  - [ ] Trigger haptics on answer events when enabled and supported
  - [ ] Guard unsupported devices to avoid crashes; persist haptics setting
- [ ] Tests
  - [ ] Widget/unit: feedback visuals fire on answer and reset; toggles persist; haptics/audio respect toggles
  - [ ] Integration (optional): happy path answering with toggles on/off

## Dev Notes

- Use existing SettingsRepository and AppSettings for persistence; default to on for sound/haptics unless user overrides.
- Ensure feedback state does not interfere with timer urgency visuals; keep UI non-blocking (Architecture).
- Fail-open for haptics on unsupported devices; log only if needed, no user-facing errors.

### Project Structure Notes

- Gameplay UI: funnums/lib/features/gameplay/gameplay_screen.dart
- Settings persistence: funnums/lib/data/models/settings.dart, funnums/lib/core/services/storage_service.dart, funnums/lib/data/sources/session_repository.dart (for gameplay state), settings repository under data/sources

### References

- Epics: docs/epics.md (Story 1.4 Feedback & Controls)
- PRD: docs/prd.md (FR-010, FR-011, FR-015)
- Architecture: docs/architecture.md (non-blocking gameplay, fail-open for optional capabilities)

## Dev Agent Record

### Context Reference

<!-- Path(s) to story context XML will be added here by context workflow -->

### Agent Model Used

BMAD SM (Scrum Master)

### Debug Log References

### Completion Notes List

### File List

### Learnings from Previous Story

- Previous story not yet implemented (no prior file available); no carryover learnings documented.
