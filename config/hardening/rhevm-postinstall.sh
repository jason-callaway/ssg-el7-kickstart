#!/bin/sh
# This script was written by Frank Caviggia, Red Hat Consulting
# Last update was 11 March 2015
# This script is NOT SUPPORTED by Red Hat Global Support Services.
# Please contact Rick Tavares for more information.
#
# Script: rhevm-postinstall.sh
# Description: Losens Hardening settings temporarily to allow registration with RHEVM 3.x
# License: GPL (see COPYING)
# Copyright: Red Hat Consulting, March 2015

# Check for root user
if [[ $EUID -ne 0 ]]; then
	tput setaf 1;echo -e "\033[1mPlease re-run this script as root!\033[0m";tput sgr0
	exit 1
fi

echo -e "\033[3m\033[1mRHEV Post-Install Script\033[0m\033[0m"

# Disallow Root Login
gpasswd -d root sshusers
sed -i "/^PermitRootLogin/ c\PermitRootLogin no" /etc/ssh/sshd_config
sed -e "/pam_succeed_if.so uid/s/^#//g" -i /etc/pam.d/password-auth

# Restart SSHD Service
systemctl restart sshd.service

# Remount /tmp Partition
mount -o remount,defaults /tmp
