if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x PATH /Users/mjuan/.volta/bin:/opt/homebrew/bin:/Users/mjuan/.local/bin:/Users/mjuan/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin $PATH

# GO
set -x GOPATH ~/go
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin

# emacs
set -x PATH $PATH ~/.config/emacs/bin

starship init fish | source

# NVim configs
# alias nvim-next='NVIM_APPNAME=nvim-next nvim'
# alias next='nvim-next'
alias n='nvim'
alias m='nvim'
alias v='nvim'

alias cls='clear'
alias cl='clear'
alias c='clear'

alias ls='eza -a --icons -l'
alias ll='ls'
alias l='ls'

alias cat='bat'

abbr tn "tmux new -s (pwd | sed 's/.*\///g')"

fish_add_path /opt/homebrew/opt/pnpm@8/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

#tmux
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
