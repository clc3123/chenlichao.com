#!/bin/bash
# A bash script to create a time machine disk image suitable for
# backups with OS X 10.6 (Snow Leopard)
# This script probably only works for me, so try it at your own peril!
# Use, distribute, and modify as you see fit but leave this header intact.
# (R) sunkid - September 5, 2009

usage ()
{
     echo ${errmsg}"\n"
     echo "makeImage.sh"
     echo "	usage: makeImage.sh size [directory]"
     echo "	Create a disk image with a max storage size of <size> and copy it"
     echo "	to your backup volume (if specified)"
}

# test if we have two arguments on the command line
if [ $# -lt 1 ]
then
    usage
    exit
fi

# see if there are two arguments and we can write to the directory
if [ $# == 2 ]
then
	if [ ! -d $2 ]
	then
 		errmsg=${2}": No such directory"
    	usage
    	exit
	fi
	if [ ! -w $2 ]
	then
		errmsg="Cannot write to "${2}
		usage
    	exit
	fi
fi

SIZE=$1
DIR=$2
NAME=`scutil --get ComputerName`;
UUID=`system_profiler | grep 'Hardware UUID' | awk '{print $3}'`

# get busy
echo -n "Generating disk image ${NAME}.sparsebundle with size ${SIZE}GB ... "
hdiutil create -size ${SIZE}G -fs HFS+J -type SPARSEBUNDLE \
	-volname 'Time Machine Backups' "${NAME}.sparsebundle" >> /dev/null 2>&1

echo "done!"

echo -n "Generating property list file with uuid $UUID ... "

PLIST=$(cat <<EOFPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>com.apple.backupd.HostUUID</key>
        <string>$UUID</string>
</dict>
</plist>
EOFPLIST)

echo $PLIST > "${NAME}.sparsebundle"/com.apple.TimeMachine.MachineID.plist
echo "done!"

if [ $# == 2 ]
then
	echo -n "Copying ${NAME}.sparsebundle to $DIR ... "
	cp -pfr "${NAME}.sparsebundle" $DIR/"${NAME}.sparsebundle"
	echo "done"
fi

echo "Finished! Happy backups!"