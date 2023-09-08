
# Update
sudo apt-get update -y && sudo apt-get upgrade -y </dev/null
printf "Update finished!\n"

# Install
sudo apt install -y curl zsh vim neofetch gcc make nasm python3 python3-pip </dev/null
printf "Packages installed!\n"

# Setup zsh
sudo curl -fsSL https://raw.githubusercontent.com/zambodev/dotfiles/master/.zshrc > ~/.zshrc
printf "Zsh setup done!\n"

# Setup vim
sudo curl -fsSL https://raw.githubusercontent.com/zambodev/dotfiles/master/.vimrc > ~/.vimrc
printf "Vim setup done!\n"

sudo chsh -s $(which zsh)
