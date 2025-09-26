# Load custom scripts 
source ~/.config/zsh/zsh_prompt
source ~/.config/zsh/zsh_aliases
source ~/.config/zsh/zsh_functions
source ~/.config/zsh/zsh_fzf
source ~/.config/zsh/zsh_gcloud
source ~/.config/zsh/zsh_keybinds
source ~/.config/zsh/zsh_options
source ~/.config/zsh/zsh_variables

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export GPG_TTY=$(tty)
export MOZ_ENABLE_WAYLAND=1

if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
    #exec sway
    exec Hyprland
fi


# pnpm
export PNPM_HOME="/home/gabwag/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.local/bin:$PATH"
