# SCHEMA: Second Brain Rules

System: WSTUNLTD™ Second Brain Omarchy by JJUANtheBRAND™
Owner: {{OWNER}}
Created: {{DATE}}
Stack: PARA (filing) + LLM Wiki (compilation) + Graph/ICM (relationships) + CEREBRO (lint)

This file is the schema. The agent reads it first in every session. The owner
and the agent revise it together. It is the most important file in the vault.

## Layout

- `1-Projects/` Time bound work with a deadline and a clear outcome.
- `2-Areas/` Ongoing responsibilities with no end date.
- `3-Resources/` Reference topics and reusable assets.
- `4-Archives/` Finished or inactive items, moved whole from the folders above.
- `raw/` Immutable sources. The agent reads raw, never edits it.
- `wiki/` Agent written pages: `people/`, `orgs/`, `concepts/`, `processes/`.
- `graph/ontology.md` Node types and allowed verbs.
- `graph/edges.md` Master triple list: subject, verb, object.
- `index.md` Master map: every wiki page, one line each.
- `log.md` Append only record of ingest and lint runs.
- `output/` Reports, including CEREBRO scans.

## Frontmatter (required on every wiki and project page)

```yaml
---
type: person | org | project | concept | process | resource
status: active | paused | archived
updated: YYYY-MM-DD
sources: []
para: 1-Projects | 2-Areas | 3-Resources | 4-Archives
deadline: YYYY-MM-DD   # optional, projects only. Powers urgency triage.
tags: []
---
```

## Linking rules (this is what makes the graph and the scanner work)

1. Link relationships with wikilinks: `[[Page Name]]`. Plain markdown links
   do not build the graph and are invisible to the scanner.
2. Every link carries a verb in the sentence around it: produces, funds,
   presents, hosts, sponsors, sells, teaches, partners-with, features,
   supports, depends-on, supersedes. Full list in `graph/ontology.md`.
3. A person, org, or concept mentioned in 2 or more pages gets its own page.
   Until then it stays on the scanner's unresolved entities list, which is
   the ingest to-do list.
4. Tag deliberately. A tag used once is an intention, not coverage.

## Operations

### Ingest
Owner drops sources in `raw/` and does not organize them. Ingestion runs
three ways: the owner runs `second-brain ingest`, a systemd path watcher
fires it when files land in `raw/`, or a nightly timer (02:00) runs it as
a batch. All three do the same delta job:

1. Delta first. A raw file is processed only when `log.md` carries a ledger
   entry naming it (`source: raw/<path>`). Everything else is pending.
   Never reprocess a file that already has an entry.
2. Before writing anything, read `index.md` and `log.md` and note the
   existing entities. Update those pages. Creating a fragmented duplicate
   of an existing entity is the worst ingest error.
3. For each pending file: read it, write a summary page from
   `templates/source-summary.md`, update every related entity and concept
   page (one source can touch 10 to 15 pages), inject `[[wikilinks]]` with
   verbs from `graph/ontology.md`, add triples to `graph/edges.md`, and
   update `index.md`.
4. Append one ledger entry per file to `log.md`, exactly in this format:

   ```
   ## YYYY-MM-DD HH:MM ingest
   - source: raw/<path>
   - pages: [[Page One]], [[Page Two]]
   - links: [[A]] -> [[B]] (verb)
   ```

   The entry is the proof of processing. The CLI verifies ingestion by
   these entries, not by your exit report, and any file missing its entry
   stays in the delta for the next run.

### Query
Agent reads `index.md` first, loads only relevant pages, answers with
citations to wiki pages and raw sources. Good answers are filed back into
the wiki as new pages.

### Lint (weekly)
1. Run `second-brain scan` (CEREBRO with --gaps). Report lands in `output/`.
2. Agent reviews the report: creates missing entity pages, adds missing
   links, links or archives orphans, flags contradictions and stale claims.
3. Append the lint date and headline findings to `log.md`.

## Model runtime

- Default runtime: LM Studio (installed through Omarchy's install menu),
  serving the local model at http://localhost:1234/v1. The model is sized
  to this machine by `second-brain model` and recorded in
  ~/.config/second-brain/config (RECOMMENDED_MODEL, MODEL_MODE).
- Mode is `local` unless the owner sets `hybrid`. Local means everything
  runs on this machine, offline, with no API key. Hybrid adds the owner's
  own official cloud API key, in the agent config only, for bigger jobs.
  Keys never live in this vault.

## Hard rules

- Raw is immutable. Synthesis lives in `wiki/` only.
- Every factual claim carries a source and a date.
- Scores from the scanner are signals, not verdicts. Structural findings
  (orphans, gaps, bottlenecks) are reliable. Semantic labels need review.
- Nothing leaves the machine unless the owner sends it. Drafts are drafts
  until the owner approves exact words.
