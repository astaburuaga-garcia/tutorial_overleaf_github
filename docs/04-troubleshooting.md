# Troubleshooting

## `Password for 'https://...@github.com':`

GitHub stopped accepting account passwords for git in 2021. The "password" it's asking for is a personal access token, not your GitHub login. The cleaner fix is to switch the remote to SSH instead:

```bash
git remote set-url github git@github.com:<youruser>/<repo>.git
git push -u github master
```

You need an SSH key on GitHub for this. See [03-authentication.md](03-authentication.md).

## `error: No such remote: 'origin'`

You didn't clone from Overleaf, so there's no `origin` to rename. Check what remotes you have, then add what's missing:

```bash
git remote -v

# If both 'overleaf' and 'github' are already there, just make sure github uses SSH:
git remote set-url github git@github.com:<youruser>/<repo>.git

# If a remote is missing, add it:
git remote add overleaf <overleaf-url>
git remote add github   git@github.com:<youruser>/<repo>.git
```

The setup section in the README uses idempotent commands that handle this automatically.

## `fatal: couldn't find remote ref main`

This whole tutorial uses `master`, not `main`, because Overleaf forces `master` and we match that on the GitHub side too. If you see this error, you renamed your local branch to `main` somewhere along the way. Two fixes:

```bash
# (a) Rename your local branch back to master:
git branch -m main master
git push -u github master

# (b) Or refresh the helper scripts from this tutorial (which all use master):
cp /groups/nils/resources/tutorial_overleaf_github/scripts/*.sh .
chmod +x *.sh
```

If your GitHub repo is already configured with `main` as its default branch and you don't want to migrate, you can keep `main` locally and edit the three helper scripts to push/pull `main` to/from GitHub, while keeping `master` for Overleaf via `git push overleaf main:master`.

## "Authentication failed"

You didn't enter the right token (Overleaf Git token, not your Overleaf password, they're different) or didn't add your SSH key to GitHub. See [03-authentication.md](03-authentication.md).

## Merge conflicts

You edited the same file in Overleaf and on the server (or two collaborators edited the same file in Overleaf). Git tells you which files conflict:

```
CONFLICT (content): Merge conflict in main.tex
```

Open the file. You'll see chunks like:

```
<<<<<<< HEAD
your version on the server
=======
the Overleaf version
>>>>>>> overleaf/master
```

Pick the right text, delete the `<<<<<<<`, `=======`, `>>>>>>>` markers, save, then:

```bash
git add main.tex
git commit -m "Resolve merge in main.tex"
./to_overleaf.sh "Resolve conflict"
```

**Prevention:** edit `.tex` only on Overleaf, edit code/figures only on the server.

## "Updates were rejected because the remote contains work that you do not have"

Overleaf moved ahead of your server copy. Pull first:

```bash
./from_overleaf.sh
./to_overleaf.sh "your message"
```

## Overleaf doesn't show my new figure

After `./to_overleaf.sh`, Overleaf needs to **pull**. Click the Git icon in Overleaf → Pull. Or wait a few minutes, Overleaf auto-pulls. Then recompile.

## I committed a big data file by mistake

Don't push it. Remove from the staged commit and from history:

```bash
git rm --cached big_data_file.csv
echo "big_data_file.csv" >> .gitignore
git commit --amend --no-edit
```

If you already pushed, ask for help, rewriting public history is a pain and it's easier to do it once with someone who's done it before.

## `./from_overleaf.sh: Permission denied`

You forgot `chmod +x *.sh`. Run it.

## Overleaf says "you do not have access to this Git repository"

Your Overleaf plan doesn't include Git access (free accounts don't). Use an institutional / Premium account.
