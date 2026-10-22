# Model Swap Durability Checklist

Purpose: prove a workflow folder tree survives a model or runtime change
with **zero edits to the folder structure**. Framework code breaks when
models evolve. Folder architecture should not. Run this checklist before a
workflow ships, and again after any major model or runtime upgrade.

## Setup

- [ ] Pick one workflow with at least one task and one subtask.
- [ ] Run `second-brain workspace check` and record a clean result.
- [ ] Hash the structure files (everything except `data/` contents):
      `find <workspace> -name prompts.md -o -name tools.json -o -name WORKFLOW.md -o -name AGENTS.md | sort | xargs sha256sum > before.txt`
- [ ] Runtime A configured: primary local runtime (for example OpenCode
      with a local Ollama model) via the operator config or AGENT_CMD.
- [ ] Runtime B configured: a different model family or vendor (for
      example a cloud model through the same or a different runtime).

## Run

- [ ] Execute the workflow end to end under Runtime A. Save outputs in the
      task's `data/` and note the run in the workflow.
- [ ] Clear only `data/` working outputs (keep inputs). Change nothing
      else in the tree.
- [ ] Switch the runtime in operator config only. No folder edits, no
      prompt edits, no tools.json edits.
- [ ] Execute the same workflow end to end under Runtime B.

## Verify

- [ ] Both runs produced the deliverable named in the task's output
      contract, in the same location and format.
- [ ] Re-hash the structure files into `after.txt`. `diff before.txt
      after.txt` is empty. This is the core assertion: the tree did not
      move, only the runtime did.
- [ ] `second-brain workspace check` still passes.
- [ ] No task folder mentions a model name, vendor, or SDK. Grep to prove
      it: `grep -ri "Muse\|gpt-\|ollama\|openai\|anthropic" <workspace>
      --include=prompts.md --include=tools.json` returns nothing except
      legitimate content references.
- [ ] Differences between the two outputs are quality differences, not
      format or contract failures. Log them in the workflow's WORKFLOW.md
      as run notes, not as folder changes.

## If a run fails

- Failure caused by a missing capability in Runtime B (for example no
  multi-step planning in a small local model): the fix is to collapse or
  split task folders deliberately, as a versioned design change, never as
  a silent runtime workaround. Record the change in WORKFLOW.md.
- Failure caused by a runtime-specific instruction hiding in a prompt:
  that is a template bug. Remove the instruction and rerun both runtimes.

## Sign-off

- Workflow: ____________  Date: ________
- Runtime A: ____________  Runtime B: ____________
- Structure hash unchanged: yes / no
- Approved tools only were used: yes / no
