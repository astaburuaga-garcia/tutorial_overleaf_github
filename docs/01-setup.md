# Detailed setup

This walks through the same steps as the README, with screenshots-friendly detail and gotchas.

## Prerequisites

- A computer with `git` installed (already there on the cluster).
- An Overleaf account on a Premium / institutional plan (HU, Charité, etc.) — Git access is **not** available on free accounts.
- A GitHub account.
- SSH access to the compute server.

## Step-by-step

### 1. Create the Overleaf project

Pick **one** of:

- **From a template**: clone or download a thesis template (e.g. `github.com/steinbrecht/template-phd-thesis`) and upload via `New Project → Upload Project`.
- **From scratch**: `New Project → Blank Project`.
- **Already have one**: skip this step.

Set the main file (usually `main.tex`) and **compile once** to confirm it works.

### 2. Enable Git access in Overleaf

Open the project, then `Menu (top-left) → Git`. Copy the URL — it looks like:

```
https://git.overleaf.com/<project-id>
```

You will be asked for a **Git token** the first time you push or pull. Generate one in `Account Settings → Git Integration → Generate token`. Save it in your password manager.

### 3. Create the GitHub repo

[github.com/new](https://github.com/new):

- **Private** (your thesis isn't public yet).
- **Do not** check "Add a README", "Add .gitignore", or any license — the repo must be empty so we can push the Overleaf history into it.
- Copy the repo URL (HTTPS or SSH).

### 4. Clone on the server

```bash
ssh user@server
cd ~                              # or wherever you want the project
git clone <overleaf-url> thesis
cd thesis
```

### 5. Wire up the two remotes

```bash
git remote rename origin overleaf
git remote add github <github-url>
git remote -v
```

Expected output:

```
github     git@github.com:youruser/thesis.git (fetch)
github     git@github.com:youruser/thesis.git (push)
overleaf   https://git.overleaf.com/<id> (fetch)
overleaf   https://git.overleaf.com/<id> (push)
```

### 6. Add the helper scripts

```bash
cp /groups/nils/resources/tutorial_overleaf_github/scripts/*.sh .
chmod +x *.sh
```

### 7. Add `.gitignore` and folders

```bash
cp /groups/nils/resources/tutorial_overleaf_github/templates/.gitignore .
mkdir -p code figures
```

Edit `.gitignore` to match your data file types.

### 8. First push to GitHub

```bash
git push -u github main
```

(If the default branch is `master`, replace `main` with `master` here and in the helper scripts.)

## Sanity check

```bash
./from_overleaf.sh        # should print "Server is up to date with Overleaf."
git log --oneline -5      # you should see the Overleaf history
git remote -v             # both remotes listed
```

If all three look right, setup is done.
