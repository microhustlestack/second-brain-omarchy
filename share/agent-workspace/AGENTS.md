# Agent Workspace: Root Routing

This folder is the execution layer. It pairs with the Second Brain vault
(the memory layer). One primary agent operates over this root. Sub-agents
are spawned scoped to a single task or subtask folder, never wider.

## The atomic triad

Every workflow task and subtask folder contains exactly:

- `prompts.md` : intent, role, guardrails, steps, output contract.
- `tools.json` : the interfaces this task may use, declared by reference.
- `data/` : inputs, references, working state, and outputs for this task.

A folder missing any leg of the triad is not a task yet. Run
`second-brain workspace check` to audit the tree.

## Execution loop

1. Read this file, then the target task's `prompts.md` in full.
2. Pull context from the Second Brain vault before improvising: read the
   vault's `index.md`, load only the relevant pages. Vault path is in
   `~/.config/second-brain/config` (VAULT=) or `$SECOND_BRAIN_HOME`.
3. Use only tools declared `approved` in the task's `tools.json`.
4. Do the work inside the task folder. Intermediate state goes in `data/`.
5. Write the deliverable where `prompts.md` says it goes. If the result is
   durable knowledge, also drop a copy in the vault's `raw/` so ingestion
   files it into the wiki.
6. If the task outgrows its folder, split it: create a subtask folder with
   its own triad (`second-brain workspace new subtask ...`).

## Guardrails (owner rules, not suggestions)

- **Self-modification is gated.** You may create new workflow, task, and
  subtask folders, prompts, and data files freely. You may NOT execute a
  tool that is not in a `tools.json`, and you may NOT add a tool entry and
  mark it `approved` yourself. New tools enter `tools.json` as
  `"status": "proposed"` and wait for owner approval.
- **Official upstreams only.** Every tool, MCP server, and package comes
  from its official source. No repackaged bundles, no unofficial mirrors.
- **Reference, do not copy.** `tools.json` names shared MCP servers,
  skills, and CLI tools by reference. Never vendor a copy of a tool into a
  task folder: 40 drifting copies is a maintenance failure.
- **Approval for outward actions.** Anything that sends, posts, publishes,
  pays, or deletes outside this workspace waits for the owner's approval
  of the exact content, whatever `prompts.md` says.
- **Model independence.** Task folders must run under any conforming agent
  runtime. Never write a model name, vendor SDK call, or runtime-specific
  instruction into a task folder. Runtime choice lives in the operator's
  config, not in the tree. See `docs/model-swap-durability-checklist.md`
  in the package repo.
