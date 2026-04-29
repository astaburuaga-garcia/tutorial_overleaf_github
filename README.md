# Thesis writing workflow: Overleaf + server + GitHub

A tutorial for setting up a writing workflow for a thesis (or any LaTeX paper) using three tools:

- **GitHub** is the canonical repo. Everything important ends up there.
- **The compute server** (ITB / Michaelis) is where work happens: figures, code, analysis.
- **Overleaf** is just for writing LaTeX in the browser.

![Workflow with GitHub as the single source of truth](docs/workflow.svg)

---

## Helper scripts at a glance

Three scripts handle the three sync directions:

| Script                          | What it does                                                | Direction                  |
| ------------------------------- | ----------------------------------------------------------- | -------------------------- |
| `./from_overleaf.sh`            | Pull the latest writing from Overleaf onto the server       | Overleaf, server          |
| `./to_overleaf.sh "msg"`        | Push new figures/code from the server to Overleaf           | server, Overleaf          |
| `./backup_to_github.sh "msg"`   | Commit + push the day's work to GitHub                      | server, GitHub            |

Plus two progress helpers that run automatically inside `backup_to_github.sh`:

| Script                | What it does                                          |
| --------------------- | ----------------------------------------------------- |
| `track_progress.sh`   | Log today's page count of `main.pdf` to `progress.csv` |
| `plot_progress.R`     | Regenerate `figures/progress.pdf` from the log         |

You don't run those two yourself. Just run `./backup_to_github.sh` once a day and the progress chart stays current.

---

## One-time setup

Three phases: Overleaf side, GitHub side, server side. Do them in order.

### A. Overleaf side

> **HU Overleaf instance**: [latex.hu-berlin.de](https://latex.hu-berlin.de). Log in with your HU account.
> If you've never used the HU Overleaf, see the official setup guide first: [HU Digital Learning, Overleaf (HDL3)](https://www.digitale-lehre.hu-berlin.de/en/hu-digital-learning-and-teaching-landscape-hdl3-1/overleaf/hdl3-overleaf).

1. Pick how to start your project:
   - **Use the bundled HU PhD template** (recommended). On the server:
     ```bash
     cd /groups/nils/resources/tutorial_overleaf_github/templates
     zip -r /tmp/phd-thesis.zip phd-thesis/
     ```
     Then in Overleaf: `New Project, Upload Project, /tmp/phd-thesis.zip`. (Download the zip to your laptop first if Overleaf can't reach the server.)
   - Or upload your own LaTeX project, or start from a blank Overleaf project.
2. Set `main.tex` as the main document. **Compile** to confirm it works.
3. Open `Menu, Git`. **Copy the URL**: `https://git.overleaf.com/<project-id>`.
4. Generate an Overleaf Git token: `Account Settings, Git Integration, Generate token`. Save it in your password manager. (Overleaf Git access requires a Premium / institutional plan.)

### B. GitHub side

1. Go to [github.com/new](https://github.com/new).
2. Name the repo (e.g. `thesis`).
3. **Private**.
4. **Leave everything else unchecked**: no README, no .gitignore, no license. The repo must be empty.
5. Copy the repo URL (SSH preferred: `git@github.com:youruser/thesis.git`).
6. If you haven't already, add an SSH key to GitHub from the server. See [docs/03-authentication.md](docs/03-authentication.md).

### C. Server side

SSH to the server, then:

```bash
# 1. Clone the Overleaf project. This is the only time you pull from Overleaf via clone;
#    after this, the server is the working copy.
cd ~                                       # or wherever you want your thesis directory
git clone <overleaf-url> thesis
cd thesis

# 2. Wire up the two remotes. Rename the default 'origin' (Overleaf) and add GitHub.
git remote rename origin overleaf
git remote add github <github-url>
git remote -v                              # sanity check, both remotes should be listed

# 3. Copy the helper scripts and .gitignore template from the tutorial.
cp /groups/nils/resources/tutorial_overleaf_github/scripts/*.sh .
cp /groups/nils/resources/tutorial_overleaf_github/scripts/plot_progress.R .
cp /groups/nils/resources/tutorial_overleaf_github/templates/.gitignore .
chmod +x *.sh *.R

# 4. Create the project folders.
mkdir -p code figures

# 5. First push to GitHub.
git push -u github main
```

> If your default branch is `master` instead of `main`, replace `main` with `master` in the last command and inside the helper scripts.

### Sanity check

```bash
./from_overleaf.sh        # should say "Server is up to date with Overleaf."
git log --oneline -5      # you should see the Overleaf history
git remote -v             # both 'overleaf' and 'github' listed
```

If all three look right, setup is done.

---

## Daily routine

```
morning   ./from_overleaf.sh                          # pull last night's writing
work      Rscript code/<something>.R                  # generate figures, write code
mid-day   ./to_overleaf.sh "Add volcano plot"         # push figures to Overleaf
          (write in Overleaf)
          ./from_overleaf.sh                          # pull writing back to server
          (continue work)
end-day   ./backup_to_github.sh "Day's work: ch3"     # backup to GitHub + update progress chart
```

The simple rule: **edit `.tex` only in Overleaf, edit code/figures only on the server.** That way you can't get merge conflicts on the same file.

For more detail and a typical-day timeline, see [docs/02-daily-workflow.md](docs/02-daily-workflow.md).

---

## Folder structure (your thesis directory after setup)

```
thesis/
├── main.tex, chapters/, references.bib    (from the template)
├── figures/                               (script outputs, .pdf, .png)
├── code/                                  (R / Python scripts)
├── data/                                  (gitignored, never committed)
├── from_overleaf.sh
├── to_overleaf.sh
├── backup_to_github.sh
├── track_progress.sh
├── plot_progress.R
├── progress.csv                           (auto-generated by track_progress.sh)
└── .gitignore
```

---

## Prerequisites

- GitHub account ([github.com](https://github.com))
- SSH access to michaelis (or another compute server)
- An SSH key or personal-access-token configured for GitHub. See [docs/03-authentication.md](docs/03-authentication.md).
- Overleaf account on a Premium / institutional plan (Charité, HU). Git access is **not** available on free accounts.
- `pdfinfo` (poppler) and `Rscript` installed on the server, only needed for the progress chart.

---

## Detailed documentation

- [docs/01-setup.md](docs/01-setup.md): the same setup with extra detail and gotchas.
- [docs/02-daily-workflow.md](docs/02-daily-workflow.md): each script with examples.
- [docs/03-authentication.md](docs/03-authentication.md): SSH keys, GitHub PAT, Overleaf Git token.
- [docs/04-troubleshooting.md](docs/04-troubleshooting.md): merge conflicts, default branch, common errors.
- [docs/OnePager.md](docs/OnePager.md): printable one-page summary.

---

## Repo contents

- `scripts/`: the helper scripts.
- `templates/phd-thesis/`: bundled HU Berlin PhD thesis template (steinbrecht).
- `templates/.gitignore`: starter `.gitignore` for LaTeX + R + Python.
- `docs/`: detailed guides and the workflow diagram.

---

## Questions?

Open an issue on this repo or ask Rosario directly.

---

## Credits

- **LaTeX template**: the bundled [`templates/phd-thesis/`](templates/phd-thesis/) is the **HU Berlin PhD thesis template by steinbrecht**: [github.com/steinbrecht/template-phd-thesis](https://github.com/steinbrecht/template-phd-thesis). Used and redistributed unchanged. Please credit the original repository when you reuse the template.
- **Helper scripts and tutorial**: Rosario Astaburuaga-García.
