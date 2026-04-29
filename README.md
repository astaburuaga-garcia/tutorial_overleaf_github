# Thesis writing workflow: Overleaf + server + GitHub

A tutorial for setting up a thesis (or any LaTeX paper) writing workflow that combines:

- **Overleaf** — for writing LaTeX collaboratively in the browser
- **A compute server** (e.g. ITB / Michaelis) — for generating figures from data
- **GitHub** — for daily version-control backups

The three live in sync via Git. This repo gives you the helper scripts and step-by-step setup.

![Workflow with GitHub as the single source of truth](docs/workflow.svg)

---

## Why this workflow?

| Place        | Role                                            |
| ------------ | ----------------------------------------------- |
| **Overleaf** | Live writing — LaTeX, references, compilation  |
| **Server**   | Live figure generation — R / Python scripts     |
| **GitHub**   | Daily backup — clean version history            |

Overleaf and the server form a **live working pair** that sync constantly during the day. GitHub gets a single tidy commit at the end of the day instead of every Overleaf auto-save.

---

## One-time setup

### 1. Get the thesis template (or your own LaTeX project)

A copy of the **HU Berlin PhD thesis template** ([github.com/steinbrecht/template-phd-thesis](https://github.com/steinbrecht/template-phd-thesis)) is bundled in this repo at [`templates/phd-thesis/`](templates/phd-thesis/). Either:

- **Use the bundled copy** (recommended — same path on every machine):

  ```bash
  cp -r /groups/nils/resources/tutorial_overleaf_github/templates/phd-thesis ~/my-thesis
  ```

- **Or download a fresh copy** from `github.com/steinbrecht/template-phd-thesis` (`Code → Download ZIP`).

You can also bring your own LaTeX project — the rest of the workflow doesn't depend on this specific template.

### 2. Upload to Overleaf

At [latex.hu-berlin.de/project](https://latex.hu-berlin.de/project) (or [overleaf.com](https://overleaf.com)):

`New Project → Upload Project` → set `main.tex` as the main document → compile to confirm.

### 3. Get the Overleaf Git URL

In Overleaf: `Menu → Git → copy URL`.

> Overleaf's Git access requires a **Premium / institutional** plan. Charité / HU institutional accounts have it.

### 4. Create an empty GitHub repo

[github.com/new](https://github.com/new) — make it **private**, do **not** initialise with a README (the repo must start empty).

### 5. On the server, clone from Overleaf and add GitHub as a second remote

```bash
git clone <overleaf-url> thesis
cd thesis
git remote rename origin overleaf
git remote add github <github-url>
git remote -v   # sanity check — you should see both
```

### 6. Add the helper scripts

Copy all five helper scripts from this repo into your `thesis/` directory:

```bash
cp /groups/nils/resources/tutorial_overleaf_github/scripts/* .
chmod +x *.sh *.R
```

You'll have:

- `from_overleaf.sh` — pull writing from Overleaf
- `to_overleaf.sh` — push figures/code to Overleaf
- `backup_to_github.sh` — daily GitHub backup (also updates the progress plot)
- `track_progress.sh` — log today's page count to `progress.csv`
- `plot_progress.R` — regenerate `figures/progress.pdf` from the log

The progress log and plot update **automatically** every time you run `backup_to_github.sh` — so just keep running it once a day and you'll get a free progress chart over time.

Requirements: `pdfinfo` (poppler) and `Rscript` (with `ggplot2` if you want the prettier version) on the server.

### 7. Create the project structure

```bash
mkdir code figures
cp /path/to/this/tutorial/templates/.gitignore .gitignore
```

Adjust `.gitignore` to your project (data file extensions, language-specific build artifacts, etc.).

### 8. First push to GitHub

```bash
git push -u github main
```

You'll be asked for credentials — see [docs/03-authentication.md](docs/03-authentication.md) for SSH key / personal access token setup.

---

## Daily routine

### Start of the day — pull what you wrote in Overleaf last night

```bash
./from_overleaf.sh
```

### After generating a new figure on the server

```bash
./to_overleaf.sh "Add volcano plot for chapter 3"
```

Then switch to Overleaf, `\includegraphics{figures/volcano.pdf}`, write your section, save.

### Back on the server to continue analysis

```bash
./from_overleaf.sh
```

### End of day — backup to GitHub (also updates progress chart)

```bash
./backup_to_github.sh "Day's work: chapter 3 figures and writing"
```

This automatically logs today's page count and regenerates `figures/progress.pdf` before the push, so the progress chart stays current with no extra effort.

---

## Folder structure

```
thesis/
├── main.tex, chapters/, references.bib    ← from the template
├── figures/                               ← script outputs (.pdf, .png)
├── code/                                  ← R / Python scripts
├── data/                                  ← gitignore'd, never committed
├── from_overleaf.sh
├── to_overleaf.sh
├── backup_to_github.sh
└── .gitignore
```

---

## What you need before Thursday's session

- [ ] **GitHub account** — sign up at [github.com](https://github.com) if needed
- [ ] **Server access** — laptop set up to SSH into the ITB / Michaelis server
- [ ] **GitHub authentication** — personal access token or SSH key configured (see [docs/03-authentication.md](docs/03-authentication.md))
- [ ] **Overleaf account** with Git access (institutional login)

---

## Repo contents

- [`scripts/`](scripts/) — the three helper scripts
- [`templates/phd-thesis/`](templates/phd-thesis/) — bundled HU Berlin PhD thesis template (steinbrecht)
- [`templates/.gitignore`](templates/.gitignore) — starter `.gitignore` for LaTeX + R + Python
- [`docs/`](docs/) — setup, daily-workflow, authentication, and troubleshooting guides
- [`docs/OnePager.md`](docs/OnePager.md) — printable one-page summary

---

## Questions?

Open an issue on this repo or ask Rosario directly.

---

## Credits

- **LaTeX template**: the bundled [`templates/phd-thesis/`](templates/phd-thesis/) is the **HU Berlin PhD thesis template by steinbrecht** — [github.com/steinbrecht/template-phd-thesis](https://github.com/steinbrecht/template-phd-thesis). Used and redistributed unchanged. Please credit the original repository when you reuse the template.
- **Helper scripts and tutorial**: Rosario Astaburuaga-García.
