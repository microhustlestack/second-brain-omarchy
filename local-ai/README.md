# Local AI tools - omarchy-ltc16gb-001

Purpose: use the local Qwen3 4B model (LM Studio, http://localhost:1234/v1, model qwen/qwen3-4b) as a direct micro-worker, not as a full agent. The full opencode agent loop took about 100 seconds per short reply on this CPU-only Tiny. Direct calls take about 3 to 20 seconds.

Run it as: ~/local-ai/local-ai <command>
A symlink is also in ~/.local/bin/local-ai, so it works when PATH includes ~/.local/bin.

## Commands

- ask "prompt" - one short direct answer. Example: local-ai ask "What is philanthropy in one sentence?"
- json "instruction" [file] - JSON only output, for structured jobs.
- summarize <file> - 3 sentences or fewer. PDF or text/markdown.
- tags <file> - JSON tags, up to 5.
- entities <file> - JSON entities, up to 10.
- triage <file> - for a new raw file: title, 1-sentence summary, topics, entities, PARA suggestion, sensitive flag. Writes JSON to ~/SecondBrain/output/triage-<name>.json for the cloud ingest to use. A toolkit module should land in 3-Resources.
- private <file> - LOCAL ONLY. Summarizes on this machine and writes to ~/local-ai/private-output/. No cloud call is made by this script.
- qa "question" [page] - answers only from one vault page. With no page given, it picks the vault page with the most keyword matches and cites it. Small context only, not whole-vault synthesis.
- batch [--limit N] [--all] - one small local call per vault page (tags and entities), written to ~/SecondBrain/output/local-batch-<date>.md. Default limit is 5 pages. Full vault batch is an overnight job, not a chat job.
- demo - 3 short offline demos with timings, for Youth Enterprise Lab / WSTUNLTD demos: local AI on restored hardware, no cloud account needed.

## Rules built in

- Every call uses /no_think for short jobs, temperature 0, and a small max_tokens budget.
- Inputs are truncated (about 8000 characters for single files, 4000 per page in batch, 6000 for QA context). Long documents need chunking or cloud synthesis; do not feed a whole book in one call.
- If the LM Studio server or model is not loaded, the script starts it (lms server start, lms load qwen/qwen3-4b) and retries.

## Local vs cloud

- Local: small jobs, triage, private content, offline work, batch overnight, demos.
- Cloud (free opencode model, or a future direct key): full ingest synthesis, long documents, multi-step agent work, whole-vault synthesis.

## Batch timer (prepared, NOT enabled)

Files in ~/local-ai/systemd/ (local-batch.service and local-batch.timer, weekly Sunday 02:00) are prepared only. To enable later, copy them to ~/.config/systemd/user/ and run: systemctl --user enable --now local-batch.timer
Do not enable it until Juan approves the schedule.

## v2 optimization (2026-10-29)

- Router v2: `local-ai route "prompt" [file] [--dry-run] [--cloud]` checks /proc/meminfo RAM and estimated tokens (chars/4). Under 500 tokens: local-small. Under 2000: local. Over 2000: cloud-recommended, with the free opencode command suggested, not run by this script. Under 1GB available: wait, free RAM first.
- Cache: repeat ask/tags/summarize/entities/triage/QA/batch jobs are cached locally in ~/local-ai/cache/ for 7 days, keyed by prompt hash. Private mode bypasses cache. `local-ai cache-stats` shows entries.
- Context tuning: tags/entities now truncate to 4000 characters, summarize to 6000, triage/QA to 6000-8000. Tags on the Philanthropy page dropped from 9.7s to 2.3s after this change.
- Trust Layer gate: `local-ai gate <green|yellow|red> "<action>" [--approve "<exact action>"]`. Green read-only allows automatically. Yellow allows only if the action matches a pattern in ~/local-ai/policy.json yellow_allowed_patterns, or with explicit approval. Red (delete, money, credentials, sending) denies unless rerun with --approve and the exact action. Every gate call is logged to ~/local-ai/audit.log. `local-ai audit` shows the last 20 entries.
- Doctor and bench: `local-ai doctor` reports RAM, model loaded, policy, cache, vault, disk. `local-ai bench` runs 3 small prompts timed, with RAM before and after.
- Previous version saved at ~/local-ai/local-ai.v1.bak.

## Try-it fix (2026-10-29)

- QA no longer searches log.md, index.md, SCHEMA.md, or AGENTS.md, which were winning on keyword count and giving vague answers. QA now picks a real content page. Tested: Trust Layer QA went from a vague log.md answer (25.5s) to a correct PROV1D3NC3 OS page answer (12.0s), and explicit-page QA gave the full green/yellow/red answer in 8.0s.
- Rule: use `qa` for vault facts, `ask` for generation only. Ask has no vault context, so a local model that never saw PROV1D3NC3 in training will invent a generic answer. That happened on the first try and is why QA exists.

## Install from GitHub

Snapshot pushes do not preserve executable mode, so after cloning run: chmod +x local-ai
Then run: ./local-ai doctor
