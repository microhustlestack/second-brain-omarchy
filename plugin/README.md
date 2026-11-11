# Second Brain for Omarchy (plugin)

A bar widget for [Omarchy](https://omarchy.org) 4 (Quattro) that shows the state of your [Second Brain](https://github.com/microhustlestack/second-brain-omarchy) vault inbox, and opens the vault when you click it.

The widget runs `second-brain status` (from the WSTUNLTD™ Second Brain Omarchy by JJUANtheBRAND™ package) and reads the pending ingestion count: the number of files sitting in your vault's `raw/` folder that have not been filed into the wiki yet. It shows that state as a brain icon in the bar that changes color. The brain is a glyph from the bar's own Nerd Font, so the color is set directly on the icon:

- Green brain: nothing waiting, the inbox is fully filed
- Amber brain, with a count next to it: files are waiting to be ingested
- Grey brain: still checking, or the `second-brain` CLI was not found

There is no text label: the brain is the label.

It is the companion plugin to the [WSTUNLTD™ Second Brain Omarchy package](https://github.com/microhustlestack/second-brain-omarchy), the Arch package that installs the vault template, the CLI, and the agent skill on Omarchy. The widget also lives inside that repository under `plugin/`; this repository is the standalone edition the Omarchy plugin system installs from.

## Install

```bash
omarchy plugin add https://github.com/microhustlestack/omarchy-second-brain-plugin
omarchy plugin enable io.github.microhustlestack.secondbrain
```

Or use Setup, then Plugins, then Add, and enable it there. It lands in the right section of the bar by default; move it with `omarchy bar move io.github.microhustlestack.secondbrain` or by dragging.

Manual install: clone this repository into `~/.config/omarchy/plugins/io.github.microhustlestack.secondbrain/`, run `omarchy-shell shell rescanPlugins`, then enable it as above.

## Remove

```bash
omarchy plugin remove io.github.microhustlestack.secondbrain
```

Manual removal: disable it first (`omarchy plugin disable io.github.microhustlestack.secondbrain`), then delete `~/.config/omarchy/plugins/io.github.microhustlestack.secondbrain/`. The widget writes no configuration of its own; its settings live inline in `~/.config/omarchy/shell.json` and are removed with the plugin entry.

## Dependencies

- Omarchy 4 (Quattro) with the shell plugin system. The widget uses only the standard plugin APIs (`qs.Ui` BarWidget, Quickshell Process and IPC).
- The `second-brain` CLI on your PATH, from the [Second Brain Omarchy package](https://github.com/microhustlestack/second-brain-omarchy) (AUR: `yay -S second-brain-git`, or the repo's `install.sh`, which installs to `~/.local/bin`). The widget reads its `second-brain status` output; it works with every shipped CLI version. Without the CLI the widget still installs and simply shows the grey unknown state.
- Optional, for click to open: Obsidian or a file manager, whichever `second-brain open` falls back to on your machine. Change the launch command in the widget settings if you open your vault another way.

## Settings

Set inline on the widget's entry in `~/.config/omarchy/shell.json`, or through the bar's widget options:

| Key | Default | What it does |
| --- | --- | --- |
| `showCount` | `true` | Off hides the pending count next to the brain icon |
| `refreshSeconds` | `60` | How often the vault inbox state is checked (15 to 600) |
| `launchCommand` | `second-brain open` | Command run when the widget is clicked |

## IPC

```bash
omarchy-shell io.github.microhustlestack.secondbrain status    # prints the pending count, or unknown
omarchy-shell io.github.microhustlestack.secondbrain refresh   # re-check now
omarchy-shell io.github.microhustlestack.secondbrain launch    # run the launch command
```

## Safety note

The widget is read-only. It runs `second-brain status`, which only reads your vault's folders and log, and it runs the launch command you configure when clicked. It never writes to the vault, never ingests anything on its own, and installs nothing.

## License

MIT. See [LICENSE](LICENSE). Copyright (c) 2026 J'Juan Wilson Jr. / Micro Hustle Stack.
