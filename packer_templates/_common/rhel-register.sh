#!/bin/bash -aux


[[ -z $rhel_username ]] && echo "rhel_username is not defined" && exit 1
[[ -z $rhel_password ]] && echo "rhel_password is not defined" && exit 1

relf=/etc/redhat-release
cmd=/bin/true
if [[ -f $relf ]]
then
  mjrel=$(awk '{ print $(NF-1) }' $relf|awk -F. '{ print $1 }')
  if [[ $mjrel -ge 8 ]]
    then
    cmd=/usr/bin/dnf
  elif [[ $mjrel -le 7 ]]
    then
    cmd=/usr/bin/yum
  fi
  if [[ -n "$rhel_username" ]] && [[ -n "$rhel_password" ]]
  then
    subscription-manager register --username="$rhel_username" --password="$rhel_password" --auto-attach
    subscription-manager repos --enable "rhel-?-server-optional-rpms" --enable "rhel-?-server-extras-rpms"
    $cmd update -yyy
    reboot
  fi
fi
