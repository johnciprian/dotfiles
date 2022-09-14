#!/usr/bin/env zsh

echo "\e[31m\n\n!! WARNING: This script will overwrite existing ZSH, Bash Profile and Oh-My-ZSH configurations !! \n"
echo "!! WARNING: Please do not open other terminal session until the scripts finishes !! \e[39m\n"

case "$(uname -s)" in
    Darwin)
        echo "\e[32m[DOT]\e[33m Darwin based environment detected ... \e[39m\n"
        echo "\e[32m[DOT]\e[34m Hack Nerd Fonts requires manual installation.. Download it from: https://github.com/source-foundry/Hack/releases/ \e[39m\n"
    ;;
    Linux)
        echo "\e[32m[DOT]\e[33m Debian based environment detected ... \e[39m\n"

        # install required dependencies 
        echo "\e[32m[DOT]\e[34m installing packages ... \e[39m\n"
        sudo apt -y install git locales > /dev/null 2>&1

        # generate utf-8 environment
        echo "\e[32m[DOT]\e[34m generating locales ... \e[39m\n"
        sudo locale-gen --purge en_US.UTF-8 > /dev/null 2>&1

        # reloads font cache
        echo "\e[32m[DOT]\e[34m rebuilding fonts ... \e[39m\n"
        fc-cache -f -v > /dev/null 2>&1
    ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        echo "\e[32m[DOT]\e[33m Windows based environment detected ... \e[39m\n"
        echo "\e[32m[DOT]\e[31m This is not a supported environment. Exiting. \e[39m\n"
        exit 1
    ;;
    *)
        echo "\e[32m[DOT]\e[31m Unable to detected the environment! \e[39m\n"
        echo "\e[32m[DOT]\e[31m This is not a supported environment. Exiting. \e[39m\n"
        exit 1
    ;;
esac

# exports the language definitions
echo "\e[32m[DOT]\e[34m exporting locales ... \e[39m\n"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# tells homebrew to do a silent install
export CI=1

# delete previous installations
echo "\e[32m[DOT]\e[34m deleting previous installation of this dotfiles ... \e[39m\n"
rm -rf ~/.oh-my-zsh/ ~/.zshrc ~/.bash_profile ~/.p10k.zsh > /dev/null 2>&1

# copies base bash profile
echo "\e[32m[DOT]\e[34m copying bash profile file ... \e[39m\n"
cp -rf .bash_profile ~/.bash_profile > /dev/null 2>&1

# install the homebrew (if stdin is available requires confirmation)
echo "\e[32m[DOT]\e[34m installing homebrew ...  \e[39m\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" > /dev/null 2>&1

case "$(uname -s)" in
    Linux)
        echo "\e[32m[DOT]\e[34m configuring homebrew ... \e[39m\n"
        # installs homebrew on the environment
        echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile

        # enables homebrew on current runtime
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    ;;
    *)
    ;;
esac

echo "\e[32m[DOT]\e[34m installing homebrew packages ... \e[39m\n"

# add brew taps
brew tap "homebrew/cask-fonts";

# installs all the required packages
brew install curl zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting nvm wget less > /dev/null 2>&1

# install fonts
brew install --cask font-inconsolata
brew install --cask font-overpass-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-source-sans-pro
brew install --cask font-bebas-neue

# creates nvm directory
mkdir ~/.nvm > /dev/null 2>&1

echo "\e[32m[DOT]\e[34m copying environment files ... \e[39m\n"

# copies the ZSH environment file
cp -rf .zshrc ~/.zshrc > /dev/null 2>&1

echo "\e[32mInstallation Finished. Exiting. \e[39m\n"

exit 0
