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
# alias nv='NVIM_APPNAME=nvim-min nvim'
alias nv='nvim'
alias n='nv'
alias m='nv'

# NVim next

# Utils
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

# tmux
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"

# pnpm
set -gx PNPM_HOME /Users/mjuan/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
