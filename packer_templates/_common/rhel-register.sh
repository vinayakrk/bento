#!/bin/bash -aux


[[ -z $rhel_username ]] && echo "rhel_username is not defined" && exit 1
[[ -z $rhel_password ]] && echo "rhel_password is not defined" && exit 1

relf=/etc/redhat-release
cmd=/bin/true
if [[ -f $relf ]]
then
  mjrel=$(awk '{ print $(NF-1) }' $relf|awk -F. '{ print $1 }')
  subscription-manager register --username="$rhel_username" --password="$rhel_password" --auto-attach
  if [[ $mjrel -ge 8 ]]
  then
    subscription-manager repos --enable "rhel-8-for-x86_64-baseos-rpms" --enable "rhel-8-for-x86_64-appstream-rpms"
    /usr/bin/dnf update -yyy
    reboot
  else
    subscription-manager repos --enable "rhel-?-server-optional-rpms" --enable "rhel-?-server-extras-rpms"
    /usr/bin/yum update -yyy
    reboot
  fi
fi
