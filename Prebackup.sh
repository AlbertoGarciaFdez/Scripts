#!/bin/sh

machine=$1
backup=${machine}_Backup

  if [ $(/usr/bin/onevm show ${machine} | grep LCM_STATE | cut -d ":" -f 2) == "RUNNING" ]; then

    #Invoke backup tool by opennebula
    /usr/bin/onevm disk-snapshot --live ${machine} 0 ${backup} >> /dev/null
    #Wait for the backup to finish
    until [  $(/usr/bin/oneimage show ${backup} | grep STATE | cut -d ":" -f 2) == "rdy" ]; do
      echo "Not Ready" >> /dev/null
    done
    #OUtput the path for snapshot
    echo $(/usr/bin/oneimage show ${backup} | grep SOURCE | cut -d ":" -f 2) 

  fi
