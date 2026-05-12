---
name: planning
description: Plan non-trivial work in a plan.md file before making changes. Use this skill when a task requires more than a small edit (~30 lines).
---

## When to create a plan

Before starting any task that is **not** a trivial edit, create a `plan.md` file in the project root.

A task is non-trivial if any of the following are true:

- The change is likely to exceed ~30 lines of code.
- The change spans multiple files.
- The task requires research, design decisions, or trade-off analysis.

Do **not** create a plan for single-line fixes, small config tweaks, quick renames, or other changes that fit on one screen without scrolling.

## What goes in plan.md

- A one-sentence summary of the goal.
- A numbered list of steps or subtasks.
- References to relevant files and line numbers (`file_path:line`).
- Any open questions or decisions that need to be made.
- A checklist (`- [ ]` / `- [x]`) to track progress.

## Workflow

1. Create `plan.md` at the project root before writing any code.
2. Verify the plan with the user and offer to step through it, making edits when suggested changes are made.
3. When the user approves the plan proceed, if prompted to revisit the plan start over from step 2.
4. Reference the plan while working — check items off as they are completed.
5. Update the plan if scope changes or new information comes up.
6. Remind the user to delete `plan.md` once the work is fully complete and merged.
