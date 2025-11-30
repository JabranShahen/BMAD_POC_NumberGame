# Story 1.15: Gameplay Layout Realign to Centered Stack

Status: done

## Story

As a player, I want the gameplay UI stacked and centered (puzzle → avatar → timer/hearts/score → prompt → answers) so I can quickly focus on the puzzle without clutter or misaligned controls.

## Acceptance Criteria

1. Puzzle card is centered above the avatar; avatar is centered above the status row.  
2. Status row centers timer chip (left), hearts (middle), score chip (right); hearts remain 5 slots and are visibly larger than the previous 22px icons.  
3. Prompt and 2x2 answers remain below, within the maxWidth column, using existing button styles/colors; no horizontal scroll on small portrait devices.  
4. “End run” link sits at the bottom-right of the content column.  
5. Layout fits small portrait screens without horizontal scroll; spacing matches the single-column reference with generous vertical padding.

## Tasks / Subtasks

- [ ] Restack gameplay_screen to centered column (puzzle → avatar → status row → prompt → answers), preserving gradient and max width. (AC1, AC3, AC4)
- [ ] Increase heart icon size in the status row; ensure 5 slots and alignment with timer/score chips. (AC2)
- [ ] Verify prompt and 2x2 answers sizing/spacing on small portrait screens; keep existing palette and shapes. (AC3, AC5)
- [ ] Keep “End run” aligned bottom-right within the content column; confirm safe-area spacing. (AC4, AC5)
- [ ] QA: Manual on small portrait device and larger device to confirm no horizontal scroll, timer urgency visibility, heart updates, score visibility. (AC5)
- [ ] Testing: Add/verify widget tests for layout stack order and heart size/state; ensure no horizontal overflow. (AC1, AC2, AC3)
- [ ] Testing: Run smoke on gameplay_screen to ensure timer urgency still visible and “End run” stays accessible. (AC4, AC5)

## Dev Notes

- Source refs: [Source: docs/tech-spec.md#UX-change-spec-—-Gameplay-layout-update], [Source: docs/ux-design-specification.md]. Epics.md does not yet list this story; treat UX handoff as source of truth.
- Architecture: follow docs/architecture.md for non-blocking gameplay, portrait-only, and reuse existing components; no new palette/asset changes. [Source: docs/architecture.md]
- Palette/components stay the same; this is a layout realign, not a visual theme change.  
- Ensure no regression to timer urgency styling and hearts decrement logic; keep non-blocking UI.
- Testing standards: add widget tests for layout stack and heart sizing; manual QA on small portrait and larger device form factors.

### Learnings from Previous Story

- Previous story 1-14-game-screen-layout-upgrade is marked done in sprint-status, but no story file was found; no continuity notes available to reuse. If the file becomes available, update this section with its learnings. [Source: docs/sprint-artifacts/sprint-status.yaml]

### Project Structure Notes

- Gameplay UI: funnums/lib/features/gameplay/gameplay_screen.dart  
- Emoji/avatar: funnums/lib/features/gameplay/widgets/emoji_avatar.dart

### References

- UX change spec — Gameplay layout update (docs/tech-spec.md)  
- UX Design Specification (docs/ux-design-specification.md)
- Architecture (docs/architecture.md)
- Sprint tracking (docs/sprint-artifacts/sprint-status.yaml)

## Change Log

- 2025-11-30: Initialized story draft; generated story context XML and marked ready-for-dev.

## Dev Agent Record

### Context Reference

docs/sprint-artifacts/1-15-gameplay-layout-realign.context.xml

### Agent Model Used

BMAD SM (Scrum Master)

### Debug Log References

### Completion Notes List

### File List
