# Subtask: citation-check

Parent task: example-task
Created: {{DATE}}

## Intent

Verify that every factual claim in the parent task's `data/brief.md`
traces to the wiki page it cites. This subtask exists to demonstrate the
pattern: when a task grows a distinct verification job, the job gets its
own folder, its own triad, and a sub-agent scoped to this folder only.

## Steps

1. Read `../data/brief.md`.
2. For each claim, open the cited wiki page in the vault and confirm the
   claim is supported there.
3. Write findings to `data/citation-report.md`: claim, verdict
   (supported, unsupported, miscited), and the correct page if miscited.

## Output contract

- Deliverable: `data/citation-report.md` in this folder.
- Report back to the parent task only. No owner-facing message.
