# Librarian - both modes (template)

Read only. Vault: ~/SecondBrain on this Omarchy machine.

Interactive:
  opencode
  Then ask in chat. The second-brain skill reads index.md first,
  loads relevant pages, and answers with citations.

Headless (for other agents and scripts):
  librarian "What is an AI Use Policy for a nonprofit?"
  librarian "What are the green, yellow, and red Trust Layer levels?"
  librarian --index "Trust Layer"

Headless uses local-ai qa: one vault page, cited, local model only,
no cloud call. If no page matches, it falls back to index search.

Rules: prompts.md in this folder. Tool status in tools.json is
proposed in this template, per the agent-workspace guardrail, pending
owner approval of the tool registration itself on each machine.
Do not copy an approved tools.json from another machine.

## Install from GitHub

Snapshot pushes do not preserve executable mode, so after cloning run:
  cp -r librarian ~/agent-workspace/librarian
  chmod +x ~/agent-workspace/librarian/librarian
  ln -sf ~/agent-workspace/librarian/librarian ~/.local/bin/librarian
Then set the owner name in prompts.md, and approve the tools in
tools.json on that machine before other agents call the librarian.
