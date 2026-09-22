# dotfiles

Portable Bash, Vim, tmux, profile, and Git configuration for a Linux development environment.

## Included configuration

- `bash/bashrc`: Bash prompt, aliases, history behavior, ysyx environment variables, and optional ble.sh integration.
- `shell/profile`: login-shell PATH setup and Bash startup.
- `vim/vimrc`: editing defaults, search behavior, split navigation, WSL clipboard integration, and plugin settings.
- `tmux/tmux.conf`: panes, mouse support, Vim-style navigation, status colors, and persistent scrollback.
- `git/gitconfig`: shared Git defaults. Personal identity stays in `~/.gitconfig.local` and is not committed.

Runtime history, editor swap files, machine state, SSH keys, and backup files are intentionally excluded.

## Install

```bash
git clone git@github.com:DCKERS611/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The installer is idempotent. Existing target files are moved to a timestamped directory under `~/.dotfiles-backup/` before symbolic links are created.

Set machine-specific Git identity in `~/.gitconfig.local`:

```ini
[user]
    name = Your Name
    email = you@example.com
```

## Reload

Start a new shell, or reload individual tools:

```bash
source ~/.bashrc
tmux source-file ~/.tmux.conf
```

Inside tmux, `Ctrl-b r` also reloads the configuration.
