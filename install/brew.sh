if test ! $(which brew); then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages..."

# cli tools
brew install ack
brew install bat
brew install fzf
brew install eza
brew install bat
brew install tree
brew install wget

# ui tools
brew install yabai
brew install skhd
brew install sketchybar

# development tools
brew install git
brew install gh
brew install hub
brew install macvim --override-system-vim
brew install reattach-to-user-namespace
brew install tmux
brew install fish
brew install highlight
brew install nvm
brew install volta
brew install z
brew install markdown
brew install lazyvim

# install neovim
brew install neovim/neovim/neovim

exit 0
