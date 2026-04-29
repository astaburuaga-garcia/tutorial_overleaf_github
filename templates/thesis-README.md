# My Thesis

> Replace this with a one-line description. The sections below marked
> `progress:start`, `progress:end`, `chapters:start`, `chapters:end` are
> regenerated automatically by `./update_readme.sh` (called from
> `./backup_to_github.sh`). Don't edit between the markers, edit elsewhere.

<!-- progress:start -->
## Progress

(no pages logged yet, run ./track_progress.sh after compiling main.pdf)

![Progress chart](figures/progress.png)
<!-- progress:end -->

<!-- chapters:start -->
## Chapters

(no chapters/ directory found)
<!-- chapters:end -->

## Repo layout

```
thesis/
├── main.tex, chapters/, references.bib    (LaTeX source)
├── figures/                               (generated plots, .pdf, .png)
├── code/                                  (R / Python scripts)
├── data/                                  (gitignored, never committed)
├── from_overleaf.sh, to_overleaf.sh,
│   backup_to_github.sh,
│   track_progress.sh, plot_progress.R,
│   update_readme.sh
└── progress.csv                           (page count log)
```

## Daily workflow

```bash
./from_overleaf.sh                                   # pull writing from Overleaf
# ...generate figures, write code on the server...
./to_overleaf.sh "Add volcano plot"                  # push figures to Overleaf
./backup_to_github.sh "Day's work: chapter 3"        # commit + update progress + push
```

For the full workflow tutorial, see [`/groups/nils/resources/tutorial_overleaf_github/`](https://github.com/astaburuaga-garcia/tutorial_overleaf_github).
