if [ $# -eq 0 ]
	then
		echo "No arguments supplied"
		exit 1
fi
	
EXCLUDE="--exclude=.virtualenvs"

export DEST_DIR=$1/$(date +%Y%m%d_%H%M%S)
mkdir $DEST_DIR

if [ $? -eq 0 ]; then
	echo "Make dir ok"
else
    	echo FAIL
		exit 1
fi

echo "Backing up Ubuntu home folder, sources, packag lists and keys to $1"
mkdir -p $DEST_DIR/meta/Sources
mkdir $DEST_DIR/data/

echo "Backing up selection, packages and repo keys...\n"
dpkg --get-selections > $DEST_DIR/meta/Package.list
sudo cp -R /etc/apt/sources.list* $DEST_DIR/meta/Sources/
sudo apt-key exportall > $DEST_DIR/meta/Repo.keys

rsync -r -a --no-links --info=progress2 $EXCLUDE /home/`whoami` $DEST_DIR/data/`whoami`
rsync -r -a --no-links --info=progress2 $EXCLUE  /opt/ $DEST_DIR/data/opt

rm -r $DEST_DIR/../latest
ln -s `basename $DEST_DIR` $DEST_DIR/../latest

notify-send 'Gerard Backup' 'IS COMPLETEEEE!!!!'
