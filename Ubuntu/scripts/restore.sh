#!/bin/sh

# Something I was fooling around with, not at all working properly. 
# More importantly, everytime I use this script, there seems to be something missing in 
# the gnome parts (no / bad UI on startup, black screens etc.) I have abandonded this for now.

# Do other setup stuff
MY_DIR="$(dirname "$0")"
exec &> $MY_DIR/logfile.txt

sh setup.sh

##  Reinstall now
if [ $# -eq 0 ]
	then
		echo "No arguments supplied"
		exit 1
fi

echo "Restoring from backup $1"

# This is still giving me headaches at the moment. It won't get past login screen, I guess it's a matter of conflicting security configs
# rsync --progress /backup_home /home/`whoami`

META=$1/meta

if [ ! -r "$META/Repo.keys" ]
then
	echo "$0: $1/Repo.keys file missing."
	exit 0	
fi

if [ ! -r "$META/Package.list" ]
then
	echo "$0: $1/Package.list file missing."
	exit 0	
fi

if [ ! -d "$META/Sources" ]
then
	echo "$0: $1/Sources directory missing."
	exit 0
fi

echo "Adding Keys ..."
sudo apt-key add $META/Repo.keys
echo "\nFinished Adding Keys ...\n\n"

sudo cp -R $META/Sources/* /etc/apt/
sudo apt-get update
sudo apt-get install -y dselect
sudo dpkg --set-selections < $META/Package.list
sudo dselect update
sudo dselect install
sudo apt-get -u dselect-upgrade

printf "Installing zsh oh-my-zsh and profiles ... \n\n"
sleep 1

sudo apt-get -y install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

cp ~/.bashrc ~/.bashrc.org
cp ~/.zshrc ~/.zshrc.org

cp ../.common_profile ~/
cp ../.zshrc ~/
cp ../.bashrc ~/

chsh -s $(which zsh)
sleep 1

printf "Installing the Python virtual environment"
sudo apt-get install -y python-pip
pip install virtualenv
mkdir ~/.virtualenvs
sudo apt-get install -y virtualenv
sudo pip install virtualenvwrapper

printf "\n Setting up mount-points for hard disks ...\n\n"
sleep 1
sudo mkdir /media/bb
sudo mkdir /media/bb_ext
sudo cp $MY_DIR/fstab /etc/fstab
sudo mount -a
ln -s /media/bb ~/bb
ln -s /media/bb_ext ~/bb_ext

printf "Installing backup_now script"
sleep 1
ln -s ~/bb/Backups/Ubuntu/Partial ~/Backups
echo "~/bb/Backups/setup-os-env/Ubuntu/scripts/backup.sh ~/Backups/" > ~/backup_now.sh

printf "Setting up crontab for backing up at reboot ... "
sleep 1
(crontab -l 2>/dev/null; echo "@reboot ~/backup_now.sh") | crontab -
