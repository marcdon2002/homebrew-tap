# Homebrew Tap

Homebrew packages for [Amber Shell](https://github.com/marcdon2002/amber-shell), a compact Zsh assistant using the official Codex CLI and your ChatGPT login.

## Install

Requires macOS 13+ on Apple Silicon and Homebrew.

```sh
brew install marcdon2002/tap/amber-shell
amber-shell-setup
```

If the official Codex CLI is not installed yet:

```sh
brew install --cask codex
```

Open a new terminal window and press **Ctrl-X**, then **Ctrl-A**. On first open, Amber shows **Log in with ChatGPT**. Press **Enter**, finish the official browser login, and Amber continues directly to the question input in the same dialog. No separate login command is required.

Amber has a separate login profile, even if you already use Codex. `amber-shell login status` checks it;
`amber-shell logout` signs out only Amber. Your personal Codex login and the
ChatGPT browser session stay signed in. For device-code login, use
`amber-shell login --device-auth`. The optional `amber-shell login` command also opens browser login. Run `amber-shell login --help` for details.

**Ctrl-Y** transfers a suggestion to the editable shell prompt; normal **Enter in the shell** executes it.

The package downloads a SHA256-verified release binary; no Rust compiler is needed. Setup backs up `.zshenv`/`.zshrc` and migrates only exact Amber-managed blocks. Existing personal shell configuration is preserved. Configuration uses Homebrew's stable `opt` path; upgrades need no repeated setup.

If an older `~/.local/bin/amber-shell` comes before Homebrew in your `PATH`, direct CLI calls can still select that old binary. The configured hotkey uses Homebrew explicitly. After successful migration, retire the old executable or use `"$(brew --prefix amber-shell)/bin/amber-shell"` for CLI calls.

For symlinked startup files, pass the resolved targets to `amber-shell-setup --zshrc /absolute/path --zshenv /absolute/path`.

## Update

```sh
brew update
brew upgrade marcdon2002/tap/amber-shell
```

Open a new terminal window after updating.

## Uninstall

First remove the marked `amber-shell capture` block from `.zshenv` and the marked `amber-shell` block from `.zshrc`, then run:

```sh
brew uninstall amber-shell
```

Local preferences and history are retained. To stop using this tap, run `brew untap marcdon2002/tap`.

## Maintenance

The upstream tagged release workflow generates `amber-shell.rb` from the exact release archive and checksum. Copy that release's formula into `Formula/amber-shell.rb`, verify with `brew audit --strict marcdon2002/tap/amber-shell` and `brew test marcdon2002/tap/amber-shell`, then commit the update. Do not reuse a checksum from a different build.

Changes to this tap are automatically checked by installing the formula, running `brew test`, and running `brew audit --strict` on a standard macOS ARM64 runner. Tests use temporary shell configuration and make no model requests.

MIT licensed. Report product issues in [amber-shell](https://github.com/marcdon2002/amber-shell/issues).
