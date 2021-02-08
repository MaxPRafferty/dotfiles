#!/usr/bin/env bash

# base installs
xcode-select --install
git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask visual-studio-code
brew install rectangle

#style
(cd ~/code/ && git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git && ./fonts/install.sh)
(cd ~/code/ && git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git)
open "https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/"

# visual studio code config
code
code --install-extension MS-vsliveshare.vsliveshare
code --install-extension vscodevim.vim



# system preferences
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
defaults write -g com.apple.swipescrolldirection -bool FALSE
defaults write com.apple.Dock autohide -bool TRUE; killall Dock
