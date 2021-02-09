#!/usr/bin/env bash

# base installs
xcode-select --install
git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask visual-studio-code
brew install rectangle
brew install --cask spotify
brew install npm
npm install -g n

#style
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
(cd ~/code/ && git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git && ./fonts/install.sh)
open "https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/"

# visual studio code config
code
code --install-extension MS-vsliveshare.vsliveshare
code --install-extension vscodevim.vim



# system preferences
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
defaults write -g com.apple.swipescrolldirection -bool FALSE
defaults write com.apple.Dock autohide -bool TRUE 
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
for d in $(defaults domains|tr -d ,);do
  osascript -e "app id \"$d\""&>/dev/null||continue
  defaults write $d SmartQuotes -bool false
  # defaults write $d SmartDashes -bool false
  # defaults write $d SmartLinks -bool false
  # defaults write $d SmartCopyPaste -bool false
  # defaults write $d TextReplacement -bool false
  # defaults write $d CheckSpellingWhileTyping -bool false
done


# a little cleanup
killall Finder
killall Dock
