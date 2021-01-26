#!/usr/bin/env bash -eux

. ~/.rhel_secrets

subscription-manager register --username="$RHEL_USERNAME" --password="$RHEL_PASSWORD" --auto-attach
subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
dnf update -yyy
dnf upgrade -yyy
reboot
