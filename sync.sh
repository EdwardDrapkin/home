TIMESTAMP=$( date -u "+%s" )
BACKUP=~/projects/
TARGET=~/OneDrive/projects.tar
#TEMP=$( mktemp /tmp/$TIMESTAMP.tar )
TEMP_DIR=$( mktemp -d )

echo $TEMP_DIR

cd $TEMP_DIR

if [ -f $TARGET ]; then
  mv $TARGET $TEMP_DIR
  7z e projects.tar.7z
  gtar xf projects.tar
  rm projects.tar.7z
fi

rsync $BACKUP "${TEMP_DIR}/projects/" -a --exclude '.yarn-mirror' --exclude 'node_modules'
gtar -cpf projects.tar projects/
/usr/local/bin/7z a -mmf=bt3 -mmc=256 -myx=9 -md=256m -ms=on -mx=9 -t7z -m0=lzma -mfb=273 projects.tar.7z projects.tar
mv "${TEMP_DIR}/projects.tar" $TARGET

rm -rf $TEMP_DIR

#/usr/local/bin/gtar --exclude=.yarn-mirror --exclude=node_modules --listed-incremental $TARGET/meta.snar -cvpf $TEMP $BACKUP  &&
#/usr/local/bin/7z a -mmf=bt3 -mmc=256 -myx=9 -md=256m -ms=on -mx=9 -t7z -m0=lzma -mfb=273 $TARGET/$TIMESTAMP.tar.7z $TEMP &&
#rm $TEMP
