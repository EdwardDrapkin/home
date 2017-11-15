TIMESTAMP=$( date -u "+%s" )
BACKUP=~/projects/
TARGET=~/Dropbox/projects/
TEMP=$( mktemp /tmp/$TIMESTAMP.tar )

/usr/local/bin/gtar --exclude=node_modules --listed-incremental $TARGET/meta.snar -cvpf $TEMP $BACKUP  &&
/usr/local/bin/7z a -mmf=bt3 -mmc=256 -myx=9 -md=256m -ms=on -mx=9 -t7z -m0=lzma -mfb=273 $TARGET/$TIMESTAMP.tar.7z $TEMP &&
rm $TEMP
