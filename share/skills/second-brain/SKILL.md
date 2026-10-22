---
name: second-brain
description: >
  Maintain a Second Brain vault built on PARA filing, LLM Wiki compilation,
  graph ontology, and CEREBRO lint. Use whenever the user asks to ingest a
  source into their second brain, query the vault, create a project, person,
  org, concept, or process page, run a vault health check, or asks "what am
  I missing" about their notes.
license: MIT
---

# Second Brain

The vault is the system. Read the vault's `SCHEMA.md` before any operation
and follow it exactly. This skill routes; the schema governs.

## Locate the vault

1. `$SECOND_BRAIN_HOME` if set.
2. `~/.config/second-brain/config` (VAULT= line).
3. Default `~/SecondBrain`.

## Operations

**Ingest.** Detection is mechanical, processing is yours. Run
`second-brain ingest --dry-run` to see the delta (raw files with no ledger
entry in `log.md`), or let the systemd path watcher / nightly timer drive
it. Sources live in `raw/` and are never edited. Before writing, read
`index.md` and `log.md` and note existing entities: update them, never
create fragmented duplicates. Write a summary from
`templates/source-summary.md`, update `index.md`, update every related page
in `wiki/` and the PARA folders, add triples to `graph/edges.md` using only
verbs from `graph/ontology.md`, and append one ledger entry per source file
to `log.md` in the exact format SCHEMA.md specifies (`source: raw/<path>`,
pages, links). One source can touch 10 to 15 pages. That is correct
behavior. The ledger entry is what marks a file processed; without it the
file returns in the next delta.

**Query.** Read `index.md` first. Load only relevant pages. Answer with
citations to wiki pages and raw sources. Offer to file a good answer back as
a new wiki page.

**New page.** Prefer the CLI: `second-brain new project|person|org|concept|process "Name"`.
It applies the template, sets frontmatter dates, and updates `index.md`.

**Lint.** Run `second-brain scan`. CEREBRO writes a gap report and JSON index
to `output/`. Work the structural findings in order: URGENT urgency signals,
unresolved entities (create the missing pages), orphans (link or archive),
bottlenecks (check freshness, everything depends on them), thin coverage.
Then do the semantic pass CEREBRO cannot: contradictions, stale claims,
superseded facts. Append the date and headline findings to `log.md`.

## Rules

- Wikilinks `[[Page Name]]` for every relationship, with a verb in the
  sentence. Plain links do not build the graph.
- Frontmatter on every page: type, status, updated, sources, para. Projects
  also carry deadline. The scanner's urgency triage reads those fields.
- Scanner scores are signals, not verdicts. Say so when content disagrees.
- The vault is private and local. Nothing is published or sent from it
  without the owner's approval of the exact words.
