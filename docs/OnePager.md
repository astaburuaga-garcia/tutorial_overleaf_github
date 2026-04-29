# Thesis workflow — one-page summary

**Three places, two roles:**

- **Overleaf + server** = live working pair. Sync constantly during the day.
- **GitHub** = daily backup. Push once or twice a day. Clean history.

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

5. Add the three scripts and `chmod +x *.sh`.
6. Create `code/`, `figures/`, `.gitignore`.

## Daily routine

| When                            | Command                                            |
| ------------------------------- | -------------------------------------------------- |
| Start of day (wrote last night) | `./from_overleaf.sh`                               |
| Generated a new figure          | `./to_overleaf.sh "Add volcano plot for ch 3"`     |
| Switching back to the server    | `./from_overleaf.sh`                               |
| End of day                      | `./backup_to_github.sh "Day's work: ..."`          |

## Folder structure

```
thesis/
├── main.tex, chapters/, references.bib   ← from the template
├── figures/                              ← script outputs (.pdf)
├── code/                                 ← R / Python scripts
├── data/                                 ← gitignored
├── from_overleaf.sh, to_overleaf.sh,
│   backup_to_github.sh
└── .gitignore
```

## Bring to Thursday

- GitHub account
- Server SSH access
- GitHub PAT or SSH key
- Overleaf account with Git access
