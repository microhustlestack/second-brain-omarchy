# WSTUNLTD™ Second Brain Omarchy by JJUANtheBRAND™

**Second Brain template for Omarchy Linux.** PARA filing + LLM Wiki
compilation + graph ontology (nodes are nouns, edges are verbs) + CEREBRO
structural lint, shipped as an Arch package, a CLI, and an agent skill.

## What is this, in plain English?

Think of your computer like your backpack at the end of a school week:
papers, screenshots, and half-finished notes stuffed everywhere. This kit
cleans the backpack, and keeps it clean.

You get two things:

1. **A Brain.** One messy inbox folder where you dump anything: voice
   notes, photos of the whiteboard, PDFs, random ideas at midnight. An AI
   helper sorts the dump into clean, linked pages, so instead of digging
   through five apps you can just ask your computer questions and get
   answers from your own files.
2. **A Workspace.** Folders for getting projects done, where every job
   keeps its instructions, its tools, and its files in one spot, like a
   recipe card sitting next to the ingredients.

It runs on your own computer with Omarchy Linux, so your stuff stays
yours. No monthly fee. No sending your life to some company's cloud.

**A generic example.** Maya is a junior. She works weekends at a sneaker
shop and sells custom phone cases online. School assignments, work
schedules, supplier prices, and customer messages used to live in five
different places and she kept missing things. Now she dumps everything
into the inbox folder. The AI files it: due dates land on her project
pages, supplier prices stay linked to her shop page, work shifts sit next
to her class schedule. Monday morning she asks one question: "What is due
this week, and what am I missing?" and gets a straight answer pulled from
her own files. When a group project starts, she makes a task folder,
drops in the rubric and the group chat notes, and the AI helps draft the
work, check the facts, and keep the deadline in sight.

## General applications: who this is for

The method is generic. Anyone whose information is scattered across
apps, downloads, screenshots, and chat threads can run the same system:

- **Students.** Class notes, assignment rubrics, group project threads,
  and work schedules in one place. Ask "what is due this week, and what
  am I missing?" and get an answer from your own files.
- **Small business owners and side hustlers.** Supplier prices, customer
  messages, receipts, and product notes filed once and linked forever,
  instead of buried in a camera roll and three inboxes.
- **Creators.** Scripts, sponsorship terms, episode notes, and asset
  links organized by project, with a workspace task for every piece of
  content from draft to published.
- **Nonprofits and community teams.** Grant deadlines, partner contacts,
  event plans, and board decisions that survive staff changes, because
  the knowledge lives in files the organization owns, not in one
  person's accounts.
- **Developers and builders.** A local memory for every project you
  maintain: decisions, setup steps, and gotchas, queryable offline.
  See the backup patterns below for how this pairs with git.
- **Families and home users.** Manuals, warranties, school paperwork,
  medical visit notes, and household projects, kept on a home machine
  instead of a subscription notes app.
- **Anyone who works with an AI assistant.** Your conversations with an
  AI contain real decisions and real work. The backup pattern below
  turns them into organized, searchable records you own.

The system it packages:

| Layer | Owns |
|---|---|
| PARA (Tiago Forte) | Where a page lives: Projects, Areas, Resources, Archives |
| LLM Wiki (Karpathy pattern) | How raw sources become a persistent, agent-maintained wiki: Ingest, Query, Lint |
| Graph / ICM | How pages connect: wikilinks with verbs, folder structure as agent routing |
| CEREBRO | Automated lint: scores, urgency, unresolved entities, orphans, bottlenecks |

## The packaging principle

Split the system into three parts that never mix:

1. **Template (data).** The vault skeleton: PARA folders, `SCHEMA.md`,
   `AGENTS.md`, graph ontology, page templates. Installed read-only to
   `/usr/share/second-brain/template`. A package upgrade replaces it, so it
   must never hold user data.
2. **CLI (code).** `second-brain`, one bash program in `/usr/bin`.
   `init` copies the template into the user's home and personalizes it.
   The vault is a copy, owned by the user, untouched by upgrades.
3. **Skill (agent instructions).** A `SKILL.md` the user's agent loads.
   It routes ingest, query, and lint work to the vault's own `SCHEMA.md`.

User data lives only in the vault (`~/SecondBrain` by default). Everything
the package owns is replaceable. That separation is what makes this a
package instead of a dotfiles dump.

## Fresh Omarchy install sequence (new or refurbished machine)

This system is designed to go on with a **fresh install of Omarchy
Linux**, on a brand-new machine or a refurbished one. The full sequence:

1. **Install Omarchy** fresh from omarchy.org. Do the base install and
   first update before anything else.
2. **Install LM Studio** from Omarchy's own install menu (Install, AI,
   LM Studio). LM Studio is the local model runtime this system uses:
   it is the GUI option Omarchy offers natively for running models on
   your own hardware (Ollama is the same menu's command-line option and
   also works, but LM Studio is the default here because owners can see
   and manage their model). Do not install model runtimes from random
   download sites: the Omarchy menu or lmstudio.ai only.
3. **Install this package** (AUR route below, or install.sh).
4. **Size the model to the machine:** run `second-brain model --save`.
   It reads the machine's RAM, CPU, and GPU and recommends a local model
   in LM Studio terms (see the sizing table below). Then download it:
   `lms get <model>` and start the local server: `lms server start`.
   LM Studio serves an OpenAI-compatible API at
   `http://localhost:1234/v1`, which is what your agent points at.
5. **Create the system:** `second-brain init --name "Owner Name"` and
   `second-brain workspace init`.
6. **Point the agent at the local model** (OpenCode or your runtime of
   choice): base URL `http://localhost:1234/v1`, model = the recommended
   one. No API key is needed in local mode.

### Local or hybrid

- **Local (default).** Everything runs on the machine. Works offline,
  nothing leaves the box, no accounts. This is the mode a refurbished
  machine in a classroom or a buyer's home should ship in.
- **Hybrid.** The local model still handles ingest, query, and daily
  tasks. The owner may add **their own official cloud API key** in the
  agent's config for bigger jobs (long synthesis, hard planning).
  Set it with `second-brain model --mode hybrid --save`. Keys live in
  the agent config, never in the vault, and never via proxy or resold-key
  tools.

### Model sizing table (capacity based)

| Machine RAM | Tier | Recommended (LM Studio, Q4_K_M) | Download |
|---|---|---|---|
| 4GB or less | minimal | Qwen3 1.7B | ~1.2GB |
| 8GB | small | Qwen3 4B | ~2.5GB |
| 16GB | mainstream | Qwen3 8B | ~5GB |
| 32GB | strong | Qwen3 14B | ~9GB |
| 64GB | workstation | Qwen3 32B | ~20GB |
| over 64GB | max | Qwen3 32B at Q5/Q8, or 70B class at Q4 | 20 to 40GB |

Rules behind the table: quantize at Q4_K_M by default (best quality per
GB), leave roughly a quarter of RAM for Omarchy and the desktop, and on
GPU machines prefer a model that fits VRAM for full speed. The 8GB row is
the validated floor: it is the class of the 2018 Mac Mini build unit.
When in doubt, `second-brain model` measures the actual machine instead
of guessing from the spec sheet.

## Install route 1: AUR (the real Omarchy route)

Omarchy is Arch. Its users install community packages with `yay`, including
through Omarchy's own menu (Install, AUR). Publish this repo's `PKGBUILD`
to the AUR and the install becomes one line:

```
yay -S second-brain-git
second-brain init
```

AUR publishing checklist:

1. Test locally on an Omarchy box: `makepkg -si` then `namcap PKGBUILD *.pkg.tar.zst`.
2. Create an AUR account, add your SSH key.
3. `git clone ssh://aur@aur.archlinux.org/second-brain-git.git`
4. Copy in `PKGBUILD` and `second-brain.install`.
5. `makepkg --printsrcinfo > .SRCINFO` (the push is rejected without it).
6. Commit both files and push. The package page appears on aur.archlinux.org.
7. Moving to a stable (non-git) package: point `source` at a release
   tarball, replace `SKIP` with its sha256 (`updpkgsums`), rename to
   `second-brain`, drop the `pkgver()` function.

Note: `makepkg` must run on Arch/Omarchy. It cannot be built or fully
tested on Debian/Ubuntu hosts.

## Install route 2: install.sh (testing today, appliances tomorrow)

```
git clone https://github.com/microhustlestack/second-brain-omarchy
cd second-brain-omarchy
bash install.sh skill vault
```

User-level only, no sudo: CLI to `~/.local/bin`, template to
`~/.local/share/second-brain/template`, skill deployed to OpenCode and
Claude Code if present, optional vault creation. This is also the route to
bake into an image before the AUR package exists.

## The CEREBRO dependency

CEREBRO ships as a Python package, not an Arch package, and Arch Python is
externally managed (PEP 668), so `pip install` system-wide is the wrong
route. The Arch-safe route is pipx:

```
pipx install git+https://github.com/microhustlestack/cerebro-skill
```

It is therefore an optdepend, not a hard depend: the template and CLI work
without it, `second-brain scan` tells the user exactly how to install it,
and `second-brain doctor` reports its status. If CEREBRO later lands in the
AUR, move it to `depends`.

## Omarchy integration points

- **Launcher:** `second-brain.desktop` lands in
  `/usr/share/applications`, so Walker and the Omarchy menu index
  "Second Brain" like any app. It runs `second-brain open`, which opens the
  vault in Obsidian (Omarchy ships it, and Omarchy themes style it) or
  falls back to the file manager.
- **Look:** The vault inherits the active Omarchy theme in Obsidian and in
  the terminal editor. No theme files of its own to maintain.
- **Menu and keybindings:** None forced. Power users can bind
  `second-brain open` or add it to their own config, which is the Omarchy
  way: user config in `~/.config` overrides, packages do not fight it.
- **Weekly lint:** A user timer is packaged but not enabled:
  `systemctl --user enable --now second-brain-lint.timer` runs the CEREBRO
  scan every Monday at 08:00 and drops the report in the vault's `output/`.
- **State:** Vault location is remembered in
  `~/.config/second-brain/config`, overridable with `$SECOND_BRAIN_HOME`.

## Companion bar plugin

The `plugin/` folder holds a companion **Omarchy bar widget** (Quattro
shell plugin, ID `io.github.microhustlestack.secondbrain`) that shows
your vault inbox state in the bar:

- **Green dot:** nothing waiting, the inbox is fully filed.
- **Amber dot with a count:** that many files are sitting in `raw/`
  waiting to be ingested.
- **Grey dot:** still checking, or the `second-brain` CLI was not found.

Clicking it opens the vault (`second-brain open`). The widget is
read-only: it runs `second-brain status`, reads the pending ingestion
count, and never writes to the vault. It works with every shipped CLI
version, and its IPC answers from a terminal:

```
omarchy-shell io.github.microhustlestack.secondbrain status   # pending count, or unknown
omarchy-shell io.github.microhustlestack.secondbrain refresh
omarchy-shell io.github.microhustlestack.secondbrain launch
```

Install it from the standalone plugin repo (the edition the Omarchy
Plugin Marketplace installs from):

```
omarchy plugin add https://github.com/microhustlestack/omarchy-second-brain-plugin
omarchy plugin enable io.github.microhustlestack.secondbrain
```

Or install manually by copying `plugin/` to
`~/.config/omarchy/plugins/io.github.microhustlestack.secondbrain/` and
enabling it as above. Validated with `omarchy plugin validate` on
Omarchy 4 and running live on the author's machine, where its status
correctly reports the vault's real pending count. Full settings and
removal instructions are in `plugin/README.md`.

## The execution layer: agent-workspace

The vault is the memory layer. Its pair is an **agent workspace**: a folder
tree of workflows, tasks, and subtasks that does the work.

```
agent-workspace/
  AGENTS.md            Root routing and guardrails for the primary agent
  _templates/task/     The scaffold every new task is copied from
  workflow-name/
    WORKFLOW.md
    task-name/
      prompts.md       Intent, guardrails, steps, output contract
      tools.json       Interfaces this task may use, by reference
      data/            Inputs, references, state, outputs
      subtask-name/    Same triad, one level down
```

Every task and subtask carries the atomic triad: **prompts, tools, data**.
One primary agent (OpenCode, Claude Code, any conforming runtime) operates
over the root; sub-agents are spawned scoped to a single task folder. The
loop with the vault runs both ways: tasks read context from the vault's
`index.md` before executing, and durable outputs are copied back into the
vault's `raw/` for ingestion.

Guardrails baked into the template's AGENTS.md:

- Agents may create folders, prompts, and data freely. A new tool enters
  `tools.json` only as `"status": "proposed"` and is not executable until
  the owner approves it. `second-brain workspace check` audits this.
- Tools are declared **by reference** (MCP server, skill, or CLI name).
  Never copy tool code into a task folder.
- No model names or vendor SDK calls inside task folders. Runtime choice
  lives in operator config, which is what makes model swaps free. The
  proof procedure is in `docs/model-swap-durability-checklist.md`: run
  the same tree under two runtimes, hash the structure files before and
  after, diff must be empty.

Commands:

```
second-brain workspace init [path]
second-brain workspace new workflow "Name"
second-brain workspace new task <workflow-slug> "Name"
second-brain workspace new subtask <workflow-slug> <task-slug> "Name"
second-brain workspace check [--strict]   # triad, JSON validity, approvals
```

## Commands

```
second-brain init [path] [--name "Your Name"]
second-brain new project|person|org|concept|process "Name"
second-brain ingest [--dry-run]   # process new raw/ files (delta vs log.md)
second-brain workspace ...        # execution layer (see above)
second-brain model [--save] [--mode local|hybrid]  # size an LM Studio model to this machine
second-brain scan        # CEREBRO --gaps report + JSON index into output/
second-brain status      # counts, last log entry, pending ingestion delta
second-brain open
second-brain doctor
```

## Automatic ingestion

Nobody should have to remember to say "ingest." Two trigger options ship
as systemd user units. Pick one, or enable both: ingestion is delta-based
(a raw file counts as processed only when `log.md` carries its ledger
entry), so repeat triggers are harmless no-ops.

**Event hook, real-time.** A path unit watches the vault's `raw/` folder
and fires the ingest service the moment files land:

```
systemctl --user enable --now second-brain-ingest.path
```

Default watched path is `~/SecondBrain/raw`. For a vault elsewhere:
`systemctl --user edit second-brain-ingest.path` and adjust the two path
lines.

**Scheduled batch, nightly.** A timer runs ingestion at 02:00:

```
systemctl --user enable --now second-brain-ingest.timer
```

**What the trigger actually runs.** `second-brain ingest`:

1. Scans `raw/` recursively (skipping `.gitkeep`), compares filenames
   against `log.md` ledger entries, builds the delta.
2. Empty delta: exits cleanly, writes nothing.
3. Writes a queue and a self-contained agent prompt into `output/`
   (`ingest-queue-<timestamp>.md`, `ingest-prompt-<timestamp>.md`). The
   prompt instructs the agent to read SCHEMA.md, index.md, and log.md
   first (update existing entities, never spawn duplicates), process each
   pending file, and append ledger entries.
4. If an agent command is configured, runs it, then **verifies by
   ledger**: any pending file still missing its log.md entry stays in the
   delta and is retried on the next run. Exit codes are not trusted;
   the ledger is the state.

Configure the agent command in `~/.config/second-brain/config` (or the
`SECOND_BRAIN_AGENT_CMD` environment variable). `{VAULT}`, `{PROMPT_FILE}`,
and `{QUEUE}` placeholders are substituted:

```
AGENT_CMD=opencode run "Read {PROMPT_FILE} and execute it"
```

Without an agent command, ingest is queue-only: safe for appliances and
for owners who want a human glance before an agent touches the vault.

Renaming a processed raw file makes it look new (its ledger entry names
the old path). The agent's index check catches the duplicate; rename the
ledger entry if you rename the source.

## Backup patterns: using the Second Brain as a local backup

The vault is plain markdown in folders you own, so it doubles as a
local backup layer. Two patterns are proven in daily use by this
project's author. Both follow the workflow rule baked into the method:
**working files live in `~/Projects/<project>/`, and the vault holds a
note in `1-Projects/` that points to them and records the decisions.**

### Pattern 1: back up a code project (example: OmaMetaMuse)

A public git repo is a cloud copy, not a backup you control. The local
backup works like this:

1. Keep a **full git clone** of the project on your own machine, in
   `~/Projects/<project>/`. A clone carries the complete history, not
   just today's files.
2. Keep a **project note in the vault** (`~/SecondBrain/1-Projects/`)
   pointing to the clone, recording what the project is, the key
   decisions (renames, releases, design choices), and what is still
   open. Code shows what was built. The note remembers why.
3. The local model can answer questions about the project offline,
   from the note and the clone, with no cloud account involved.
4. **Refresh** by running `git pull` in the clone. **Restore** by
   pushing the same clone to a new repo if the original host or
   account is ever lost.

Worked example: OmaMetaMuse (a Muse launcher package for Omarchy,
https://github.com/microhustlestack/OmaMetaMuse) is backed up exactly
this way on the author's studio machine, alongside this package.

### Pattern 2: back up your AI assistant chats

Long AI conversations hold decisions, drafts, and finished work, and
most platforms give you no good way to keep them. The pattern:

1. For each conversation, save **one summary file**: what it was about,
   the decisions made, and the key files or links it produced. One file
   per chat keeps it scannable. This is an organized record, not a
   word for word transcript.
2. File the summaries the Second Brain way: **one folder per chat or
   project**, using the same names you see in the app, so the backup
   mirrors the live workspace instead of inventing a second system.
3. Store the working set in `~/Projects/<chat-backups>/` on a local
   machine, and add a vault note in `1-Projects/` pointing to it,
   noting the transfer method and any redactions.
4. A nightly job can refresh only the chats that are new or changed,
   verify transfers with a SHA-256 hash check, and stay silent unless
   something fails or something new lands.
5. Keep private chat records off cloud drives by default. Move them
   device to device, or encrypt before any cloud copy. The author's
   setup moves these summaries device to device only, with a redaction
   check on sensitive files before anything ships.

This pattern works with any AI assistant whose conversations you can
read back, including Meta's Muse, because the record is just markdown
summaries you write and own.

### What these backups are, and are not

- They **are** local, plain-file, fully restorable records of your
  projects and your AI work, independent of any one company or account.
- They are **not** automatic sync. Refreshing a clone or a chat backup
  is a deliberate step (or a scheduled job you set up and can inspect).
- They are **not** verbatim archives. Summaries capture decisions and
  outputs. If you need full transcripts, also keep the platform's own
  data export.
- The vault itself should follow the same rule it teaches: keep at
  least two copies on different devices, and treat any cloud copy as
  your choice, not a default.

## For AI appliances (bake-in)

On a turnkey appliance (a new or refurbished machine with a fresh Omarchy
install, LM Studio + OpenCode + a local model sized to the machine), this
package is the out-of-box knowledge system:

1. Follow the fresh install sequence above on the machine. In the
   bake-in phase, run `bash install.sh skill` as the buyer user,
   `second-brain model --save` (mode local), download the recommended
   model with `lms get`, then `second-brain init` with the buyer's name
   and `second-brain workspace init`.
2. Everything runs locally after install: template, scanner, and the local
   model doing ingest and query. No account, no cloud, no API key required
   for the base system. Buyers can switch to hybrid and add their own key
   for bigger models.
3. Do not pre-populate the vault with demo content that looks like the
   buyer's data. Ship the clean template, the ontology, and one example
   page clearly marked as an example.

## Repo layout

```
PKGBUILD                 AUR recipe (second-brain-git)
second-brain.install     pacman post-install instructions
install.sh               User install + appliance bake-in route
bin/second-brain         The CLI
share/template/          The vault skeleton (installed read-only)
share/agent-workspace/   Execution layer template (workflows, task triads)
docs/                    Model swap durability checklist
share/skills/second-brain/SKILL.md   Agent skill definition
plugin/                  Companion Omarchy bar widget (manifest.json, BarWidget.qml)
share/applications/      Launcher desktop entry
contrib/systemd/         Lint timer (weekly), ingest path watcher (real-time),
                         ingest timer (nightly 02:00 batch)
```

## License

MIT. See LICENSE. CEREBRO is a separate MIT project:
https://github.com/microhustlestack/cerebro-skill
