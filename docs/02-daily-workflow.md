# Daily workflow

Three scripts. Three moments in the day.

## `./from_overleaf.sh` — start of session, or after writing in Overleaf

Pulls the latest Overleaf changes onto the server.

```bash
./from_overleaf.sh
```

Run this:
- First thing in the morning if you wrote on Overleaf the night before.
- Any time you switched to Overleaf to write and now you're back on the server.

## `./to_overleaf.sh "message"` — pushed a new figure / script change

Stages everything new, commits with your message, pushes to Overleaf.

```bash
./to_overleaf.sh "Add volcano plot for chapter 3"
```

Then in Overleaf:
1. Click the **Git** icon → **Pull** (or wait — Overleaf pulls automatically every few minutes).
2. Add `\includegraphics{figures/volcano.pdf}` where you want it.
3. Recompile.

## `./backup_to_github.sh "message"` — end of day

Pushes the day's combined work to GitHub for safekeeping.

```bash
./backup_to_github.sh "Chapter 3 figures and writing"
```

Run this **once or twice a day**, not after every change. The point is a clean version history with meaningful commit messages, not a wall of "wip" commits.

## A typical day

```
09:00  ./from_overleaf.sh          # pull last night's writing
09:30  Rscript code/volcano.R      # generate a figure
10:00  ./to_overleaf.sh "Add volcano plot"
10:05  [switch to Overleaf, write the section]
12:00  ./from_overleaf.sh          # pull the writing back
12:15  Rscript code/heatmap.R
13:00  ./to_overleaf.sh "Add heatmap for fig 4"
       [more writing in Overleaf]
17:00  ./from_overleaf.sh          # final pull
17:05  ./backup_to_github.sh "Day's work: chapter 3 figures and writing"
```

## What if Overleaf and server changed the same file?

Git will refuse to pull and tell you there are conflicts. See [03-troubleshooting.md](03-troubleshooting.md#merge-conflicts).

The simple rule: **only edit `.tex` files in Overleaf. Only edit code and generate figures on the server.** Then conflicts can't happen on the same file.
