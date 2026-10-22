# Workflow: example-workflow

A minimal working example of the execution layer, kept deliberately small.
It shows the roundtrip between this workspace and the Second Brain vault:
tasks pull context from the vault, produce work, and return durable
results to the vault's raw/ for ingestion.

Tasks:

- `example-task/` : brief the owner on one topic from vault knowledge.
  Contains one subtask to show how a task splits when it grows.

Copy this workflow as a starting point, or scaffold fresh ones with:

```
second-brain workspace new workflow "My Workflow"
second-brain workspace new task my-workflow "My First Task"
```
