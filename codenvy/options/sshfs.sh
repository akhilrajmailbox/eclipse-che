#!/bin/bash

if [[ $1 = "sync" ]];then
CODENVY_SERVER="$(zenity --entry --title="Codenvy Server IP" --text="Enter the IP Address")"
CODENVY_PORT_NUMBER="$(zenity --entry --title="Workspace Port Number" --text="Enter the Port Number")"
MOUNT_LOCATION="$(zenity --title="Choose the Mount Location" --file-selection --directory)"


 if ! dpkg --list sshfs &> /dev/null
 then
echo -e '\E[33m'" the system required 'dpkg --list sshfs' for run this script $A"
echo -e '\E[33m'" It may take a while $A"
echo ""
sudo apt-get install sshfs
 fi


  if ssh -q root@$CODENVY_SERVER -p $CODENVY_PORT_NUMBER exit > /dev/null; then
echo "Authorized"
sshfs root@$CODENVY_SERVER:/projects $MOUNT_LOCATION -p $CODENVY_PORT_NUMBER
  else
echo "unauthorized"
echo "Please check the ssh key files"

cat <<EOF > $HOME/temp
!!! WARNING !!!
You are unauthorized to the Workspace


Your Condeny Workspace info ::
Please Check it .......!


Codenvy Server IP Address :: $CODENVY_SERVER
Condenvy Workspace ssh Port :: $CODENVY_PORT_NUMBER
EOF

cat $HOME/temp | zenity --text-info
rm -rf $HOME/temp
  fi
elif [[ $1 = "unmount" ]];then
MOUNT_LOCATION="$(zenity --title="Where is the Mount Point" --file-selection --directory)"
sudo umount $MOUNT_LOCATION
else
echo "options (sync | unmount)"
echo "task aborting...........!"
fi
