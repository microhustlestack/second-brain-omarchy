# Task: example-task

Workflow: example-workflow
Created: {{DATE}}

## Intent

Produce a one-page brief on a topic the owner names, sourced entirely
from the Second Brain vault, so the owner can see the workspace and the
vault working as one system.

## Role and guardrails

- You are the agent for this folder only.
- Use only what the vault contains. If the vault does not cover the topic,
  say so in the brief. Never fill gaps from general knowledge without
  marking the paragraph as unverified.

## Inputs

- The topic: the owner supplies it when assigning the task.
- Context: vault `index.md` first, then the 2 to 3 most relevant pages.

## Steps

1. Read the vault index. Select the relevant pages. Read them.
2. Draft the brief in `data/brief.md`: summary, key facts with the wiki
   page each came from, open questions.
3. Delegate the citation check to `subtask-01` if one is configured:
   spawn a sub-agent scoped to that folder only.
4. Report back to the owner with the brief attached.

## Output contract

- Deliverable: `data/brief.md`.
- Also copy the final brief to the vault's `raw/` (durable knowledge
  returns to the brain).
- Report back: 2 to 3 sentence summary. No outward sending.
