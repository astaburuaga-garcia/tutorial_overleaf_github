# Thesis workflow — one-page summary

**Three places, three roles:**

- **GitHub** = single source of truth. Canonical repo. Where everything ends up.
- **Server** = where everything happens. R / Python / figures.
- **Overleaf** = just for writing LaTeX.

The server pushes/pulls to GitHub via helper scripts. Overleaf occasionally syncs writing back to the server.

## One-time setup

1. Get template → upload to Overleaf → confirm it compiles.
2. Overleaf `Menu → Git` → copy URL.
3. Create empty private GitHub repo (no README).
4. On the server:

   ```bash
   git clone <overleaf-url> thesis
   cd thesis
   git remote rename origin overleaf
   git remote add github <github-url>
   ```

5. Add the helper scripts and `chmod +x *.sh *.R`.
6. Create `code/`, `figures/`, `.gitignore`.

## Daily routine

| When                            | Command                                            |
| ------------------------------- | -------------------------------------------------- |
| Start of day (wrote last night) | `./from_overleaf.sh`                               |
| Generated a new figure          | `./to_overleaf.sh "Add volcano plot for ch 3"`     |
| Switching back to the server    | `./from_overleaf.sh`                               |
| End of day — push to GitHub     | `./backup_to_github.sh "Day's work: ..."`          |

`backup_to_github.sh` also auto-runs `track_progress.sh` and `plot_progress.R` to keep the page-count chart fresh.

## Folder structure

```
thesis/
├── main.tex, chapters/, references.bib   ← from the template
├── figures/                              ← script outputs (.pdf)
├── code/                                 ← R / Python scripts
├── data/                                 ← gitignored
├── from_overleaf.sh, to_overleaf.sh,
│   backup_to_github.sh,
│   track_progress.sh, plot_progress.R
└── .gitignore
```

## Bring to Thursday

- GitHub account
- Server SSH access
- GitHub PAT or SSH key
- Overleaf account with Git access
