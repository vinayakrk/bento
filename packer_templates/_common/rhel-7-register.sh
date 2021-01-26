#!/usr/bin/env bash -eux

. ~/.rhel_secrets

subscription-manager register --username="$RHEL_USERNAME" --password="$RHEL_PASSWORD" --auto-attach
subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"
yum update -yyy
reboot
