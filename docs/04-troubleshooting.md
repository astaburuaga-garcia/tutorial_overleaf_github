# Troubleshooting

## `Password for 'https://...@github.com':`

GitHub stopped accepting account passwords for git in 2021. The "password" it's asking for is a personal access token, not your GitHub login. The cleaner fix is to switch the remote to SSH instead:

```bash
git remote set-url github git@github.com:<youruser>/<repo>.git
git push -u github main
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
>>>>>>> overleaf/main
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

## Default branch is `master`, not `main`

Older repos use `master`. Either:

- **Rename to `main`** (cleanest):

  ```bash
  git branch -m master main
  git push -u github main
  git push -u overleaf main
  ```

- **Or edit the helper scripts** to use `master`:

  ```bash
  sed -i 's/main/master/g' *.sh
  ```

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
