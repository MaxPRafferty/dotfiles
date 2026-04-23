#!/usr/bin/env bash

# base installs
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# apps
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install rectangle

# node / bun
brew install npm
curl -fsSL https://bun.sh/install | bash

# shell theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# oh-my-zsh (if not already installed)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# visual studio code extensions
code --install-extension vscodevim.vim
code --install-extension esbenp.prettier-vscode
code --install-extension github.copilot
code --install-extension MS-vsliveshare.vsliveshare

# system preferences
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
defaults write -g com.apple.swipescrolldirection -bool FALSE
defaults write com.apple.Dock autohide -bool TRUE
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write -g AppleInterfaceStyle Dark
for d in $(defaults domains|tr -d ,); do
  osascript -e "app id \"$d\""&>/dev/null || continue
  defaults write $d SmartQuotes -bool false
done

# a little cleanup
killall Finder
killall Dock
