mkdir ~/Git/
cd ~/Git/

sudo apt-get install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

git clone https://github.com/gerardsimons/bash-zsh-profiles.git
cp ~/.bashrc ~/.bashrc.org
cp ~/.zshrc ~/.zshrc.org

cp ~/Git/bash-zsh-profiles/Ubuntu/.* ~/

chsh -s $(which zsh)

echo "Shell changed... logging out"
sleep 3
gnome-session-quit
