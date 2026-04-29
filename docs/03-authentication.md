# Authentication

You'll be authenticating against three services from the server: Overleaf, GitHub, and the server itself.

## SSH to the server

If you can already `ssh user@server` from your laptop, you're set. Otherwise, ask the server admin (Nils' group: Rosario, or your IT contact) for an account and configure your SSH key.

## GitHub: SSH key (recommended)

### One-time, on the server:

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
# press enter to accept the default path; set a passphrase if you want
cat ~/.ssh/id_ed25519.pub
```

Copy the printed line. On GitHub: `Settings → SSH and GPG keys → New SSH key`, paste, save.

Test:

```bash
ssh -T git@github.com
# Hi <username>! You've successfully authenticated…
```

When you create the GitHub remote, use the **SSH URL** (`git@github.com:user/repo.git`), not the HTTPS one.

### Alternative: personal access token

If you must use HTTPS:

1. GitHub → `Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token`.
2. Scope: only the thesis repo. Permission: **Contents: Read and write**.
3. Copy the token.
4. First `git push github main` → username = your GitHub username, password = the token.
5. Cache it: `git config --global credential.helper store` (saves plaintext in `~/.git-credentials`) or use the OS keychain helper.

## Overleaf: Git token

Overleaf only supports HTTPS + token (no SSH).

1. Overleaf → `Account Settings → Git Integration → Generate token`.
2. First `git pull overleaf main` or `git push overleaf main` → username = your Overleaf email, password = the token.
3. Same caching options as GitHub above.

## If a push asks for credentials every time

You forgot to enable a credential helper. On the server:

```bash
git config --global credential.helper store
```

Then push once — the credentials are remembered after that.

## Rotating tokens

If a token leaks (e.g. accidentally committed), revoke it in the respective settings page and generate a new one. Old caches in `~/.git-credentials` will fail the next push and you re-enter the new token.
