# Agent entry point

Read `SCHEMA.md` first. It holds the layout, frontmatter spec, linking
rules, and the ingest, query, and lint workflows for this vault.

Quick routing:

| Task | Load first |
|---|---|
| Add new material | `SCHEMA.md`, then the source in `raw/` |
| Answer a question | `index.md`, then only the relevant pages |
| Weekly health check | Run `second-brain scan`, then work the report in `output/` |
| Create a page | Copy the matching file from `templates/` |
| Model a relationship | `graph/ontology.md` for allowed node types and verbs |
