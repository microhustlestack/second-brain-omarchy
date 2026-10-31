# Librarian - Second Brain (template)

Vault: ~/SecondBrain (owner: set your name at install). This librarian is READ ONLY.
It never ingests, never writes vault pages, never edits raw/, index.md,
log.md, or graph/edges.md. Writing and ingest are a separate job.

## Rules, from the vault SCHEMA and the local-ai README

1. Read index.md first. Load only relevant pages.
2. Answer only from vault context. If it is not in the vault, say so.
3. Cite the source page at the end of every answer.
4. Use qa for vault facts, ask for generation only. Ask has no vault
   context, so a local model that never saw a topic in training will
   invent a generic answer. That is why qa exists.
5. Never invent a page, a date, a quote, or a link. If a page is missing,
   name the gap and offer to ingest it as a separate job.
6. Private content stays local. Headless librarian uses the local
   Qwen3 4B model only. No cloud call is made by local-ai.

## Interactive mode (chat with a person)

Run opencode in a terminal on this machine. The second-brain skill is
already deployed at ~/.config/opencode/skills/second-brain.

  opencode

Then ask the librarian question in chat. Opencode follows the skill:
read index first, load relevant pages, answer with citations.
Local model is slow for a full agent loop (about 100 seconds in the
original Tiny test), so interactive librarian chats are best for multi-page
questions, follow-ups, and synthesis across pages, not single facts.

## Headless mode (called by another agent or script)

  librarian "question"
  librarian "question" path/to/page.md
  librarian --index "search term"

Headless librarian is the wrapper script in this folder, symlinked to
~/.local/bin/librarian. It calls ~/local-ai/local-ai qa, which:
- picks the vault page with the most keyword matches, excluding
  log.md, index.md, SCHEMA.md, and AGENTS.md
- answers only from that page, up to 6000 characters of context
- cites the source page, with timing in brackets
If qa finds no matching page, the wrapper falls back to an index
search and lists matching index lines, so the calling agent can
retry with an explicit page or report the gap.

Headless is best for single-fact lookups. Tested on the original Tiny:
explicit-page QA 8.0 seconds, auto-page QA 12.0 seconds, both correct.

## What to return

A short answer, the source page name, and, for headless calls, the
timing line from local-ai qa. Nothing else is required.
