#!/usr/bin/env bash

set -euo pipefail

dotfiles_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
backup_created=false

link_file() {
    local source_path="$dotfiles_dir/$1"
    local target_path="$HOME/$2"
    local current_target=""

    if [ ! -e "$source_path" ]; then
        printf 'Missing source: %s\n' "$source_path" >&2
        return 1
    fi

    if [ -L "$target_path" ]; then
        current_target="$(readlink -f -- "$target_path" 2>/dev/null || true)"
        if [ "$current_target" = "$(readlink -f -- "$source_path")" ]; then
            printf 'Already linked: %s\n' "$target_path"
            return
        fi
    fi

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        local relative_path="${target_path#"$HOME"/}"
        local backup_path="$backup_dir/$relative_path"
        mkdir -p -- "$(dirname -- "$backup_path")"
        mv -- "$target_path" "$backup_path"
        backup_created=true
        printf 'Backed up: %s -> %s\n' "$target_path" "$backup_path"
    fi

    ln -s -- "$source_path" "$target_path"
    printf 'Linked: %s -> %s\n' "$target_path" "$source_path"
}

link_file bash/bashrc .bashrc
link_file shell/profile .profile
link_file vim/vimrc .vimrc
link_file tmux/tmux.conf .tmux.conf
link_file git/gitconfig .gitconfig

if [ ! -e "$HOME/.gitconfig.local" ]; then
    cp -- "$dotfiles_dir/git/gitconfig.local.example" "$HOME/.gitconfig.local"
    chmod 600 "$HOME/.gitconfig.local"
    printf 'Created: %s (set your Git name and email here)\n' "$HOME/.gitconfig.local"
fi

if [ "$backup_created" = true ]; then
    printf 'Existing files were preserved in %s\n' "$backup_dir"
fi

printf 'Dotfiles installation complete.\n'
