#!/bin/bash

machine=$1
backup=${machine}_Backup
diskid=$(onevm show | sed -n -e '/VM DISKS/,/VM NICS/ p' | awk '/OS/ {print $1}')

  if [ $(/usr/bin/onevm show ${machine} | grep LCM_STATE | cut -d ":" -f 2) == "RUNNING" ]; then

    #Invoke backup tool by opennebula
    /usr/bin/onevm disk-saveas --live ${machine} ${diskid} ${backup} >> /dev/null
    #Wait for the backup to finish
    until [  $(/usr/bin/oneimage show ${backup} | grep STATE | cut -d ":" -f 2) == "rdy" ]; do
      echo "Not Ready" >> /dev/null
    done
    #OUtput the path for snapshot
    echo $(/usr/bin/oneimage show ${backup} | grep SOURCE | cut -d ":" -f 2) 

  fi
