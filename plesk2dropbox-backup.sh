#!/bin/bash
# ---------------------------------------------------------------------------
#
# Copyright 2016
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at  for
# more details.
#
# Usage: plesk2dropbox-backup.sh [-v : Verbose Mode] [-r : Run Backup] [-s : Dropbox Status] [-h : Display Help]
#
# 09-27-2014 Created by Brian Aldridge - www.BiteOfTech.com
# ---------------------------------------------------------------------------
export TERM=${TERM:-dumb}
PROGNAME=${0##*/}
plesk2dropboxVersion="0.4.2"
#Grab path that is compatible with various distros.
PRODUCT_ROOT_D=`grep PRODUCT_ROOT_D /etc/psa/psa.conf | awk '{print $2}'`
#Setting colors for display.
red="\033[31m";yellow="\033[33m";green="\033[32m";nocolor="\033[0m"
#Finds the day of the week.
currentday="$(date +"%A")"
# Global variables
if [ -f "/etc/plesk2dropbox/plesk2dropbox.cfg" ]; then
    source /etc/plesk2dropbox/plesk2dropbox.cfg
else
    mkdir -p /etc/plesk2dropbox/
    touch /etc/plesk2dropbox/plesk2dropbox.cfg
    echo '#Change to the temporary folder to store your backup file.' >> /etc/plesk2dropbox/plesk2dropbox.cfg
    echo 'backuplocation="/var/backups" #CHANGEME' >> /etc/plesk2dropbox/plesk2dropbox.cfg
    echo '#Location of your Dropbox Backup Folder' >> /etc/plesk2dropbox/plesk2dropbox.cfg
    echo 'dropboxfolder="/root/Dropbox/Backups" #CHANGEME' >> /etc/plesk2dropbox/plesk2dropbox.cfg
    echo '#This is the usual location of the Plesk backup files.' >> /etc/plesk2dropbox/plesk2dropbox.cfg
    echo 'backupsource="/var/lib/psa/dumps"' >> /etc/plesk2dropbox/plesk2dropbox.cfg
    source /etc/plesk2dropbox/plesk2dropbox.cfg
fi
#Finds the most recent server backup created in Plesk.
currentbackup="$(ls -Art $backupsource/*.xml | tail -n 1)"
#Gets just the filename for display purposes.
backupname="$(ls -1 $currentbackup | sed 's/^.*\///')"
#Displays Help
usage()
{ echo -e "Usage: $PROGNAME [${red}-v${nocolor} : Verbose Mode] [${red}-r${nocolor} : Run Backup] [${red}-s${nocolor} : Dropbox Status] [${red}-u${nocolor} : Update Plesk2Dropbox] [${red}-h${nocolor}: Display Help]"
}
#Catch options
while getopts "vrsuh" opt; do
  case $opt in
    (v)
        #Script version
        plesk2dropboxLatest=`curl -s https://raw.githubusercontent.com/BoiseComputer/Plesk2Dropbox/master/.version`
        if [[ $plesk2dropboxLatest > $plesk2dropboxVersion ]]; then
        echo ;echo -e "${red}NOTICE: ${yellow}A newer version of the Plesk2Dropbox script is available.${nocolor}"
        echo "Newest Version : $plesk2dropboxLatest"
        echo "Current Version: $plesk2dropboxVersion";echo
        fi

        #Check if Backup Location directory exists
        if [ -d $backuplocation ]; then
                echo -e "${green}SUCCESS:${nocolor} The Backup Location directory exists"
        else
                echo -e "${red}ERROR:${nocolor} The Backup Location directory does not exist"
        fi

        #Check if Backup Source directory exist
        if [ -d $backupsource ]; then
                echo -e "${green}SUCCESS:${nocolor} The Backup Source directory exists"
        else
                echo -e "${red}ERROR:${nocolor} The Backup Source directory does not exist"
        fi

        #Check if Dropbox Backup directory exist
        if [ -d $dropboxfolder ]; then
                echo -e "${green}SUCCESS:${nocolor} The Dropbox Backup directory exists"
        else
                echo -e "${red}ERROR:${nocolor} The Dropbox Backup directory does not exist"
        fi
        #Check to see if Plesk Backup script exists.
        FILE=~/fullbackup.php
        if [ -f $FILE ]; then
                echo -e "${green}SUCCESS:${nocolor} The Plesk Backup Script Exists."
        else
                echo -e "File $FILE does not exist."
            echo -e "Downloading the Plesk Backup script for command line."
                wget www.biteoftech.com/fullbackup.php -O ~/fullbackup.php
                chmod u+x ~/fullbackup.php
        fi
        #Information output
        echo;echo -e "${red}NOTICE: ${nocolor}Some of these settings can be customized by editing ${yellow}/etc/plesk2dropbox/plesk2dropbox.cfg${nocolor}"
        echo -e "${green}***CURRENT SETTTINGS***${nocolor}"
        echo -e "Current Backup   : "${red}$currentbackup${nocolor}
        echo -e "Backup Name      : "${red}$backupname${nocolor}
        echo -e "Backup Location  : "${red}$backuplocation${nocolor}
        echo -e "Backup Source    : "${red}$backupsource${nocolor}
        echo -e "Dropbox Folder   : "${red}$dropboxfolder${nocolor}
        echo -e "Current Day      : "${red}$currentday${nocolor};echo

        echo -e "The backup named ${yellow}$backupname${nocolor} will be exported to DropBox under the filename ${yellow}$currentday.tar.gz${nocolor}";echo
        echo -e "${green}The following commands would be run by issuing the ${red}-r${green} command:${nocolor}"
        echo -e "Example Output: ${yellow}~/fullbackup.php -e $currentbackup $backuplocation/$currentday.tar.gz${nocolor}"
        echo -e "Example Output: ${yellow}mv -f $backuplocation/$currentday.tar.gz $dropboxfolder/${nocolor}";echo
      ;;
    (r)
        echo -e "Exporting backup to TAR file."
        ~/fullbackup.php -e $currentbackup $backuplocation/$currentday.tar.gz
        echo -e "Export done."
        echo -e "Copying file to Dropbox."
        mv -f $backuplocation/$currentday.tar.gz $dropboxfolder/
        echo -e "Copy done."
     ;;
    (s)
        echo -e "Checking the status of Dropbox."
                dropbox status
     ;;
    (u)
        #Script version
        plesk2dropboxLatest=`curl -s https://raw.githubusercontent.com/BoiseComputer/Plesk2Dropbox/master/.version`
        if [[ $plesk2dropboxLatest > $plesk2dropboxVersion ]]; then
        echo -e "${red}NOTICE: ${yellow}A newer version of the Plesk2Dropbox script is available.${nocolor}"
        read -p "Would you like to upgrade Plesk2Dropbox from v$plesk2dropboxVersion to v$plesk2dropboxLatest? (y/n):" -n 1 -r
        echo -en "\n"
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                curl https://raw.githubusercontent.com/BoiseComputer/Plesk2Dropbox/master/plesk2dropbox-backup.sh > ./$PROGNAME
                echo -e "${green}Plesk2Dropbox has been updated to the most recent version.${nocolor}"
                exit 0
            fi
        else
        echo -e "You are already running the most recent version of Plesk2Dropbox"
        fi
     ;;
    (h)
        usage
        echo
        echo -e " ${red}-v${nocolor} : ${yellow}Displays a detailed output of settings and verifies all folders exist.${nocolor}"
        echo -e " ${red}-r${nocolor} : ${yellow}Runs the script. If running in a cron job you will need to run this argument.${nocolor}"
        echo -e " ${red}-s${nocolor} : ${yellow}Checks the current status of any Dropbox uploads and downloads.${nocolor}"
        echo -e " ${red}-u${nocolor} : ${yellow}Check for an update to Plesk2Dropbox Github.${nocolor}"
        echo -e " ${red}-h${nocolor} : ${yellow}Displays this help page.${nocolor}";echo
        echo -e "This script was developed by Brian Aldridge. For updates and contact information please visit http://www.BiteOfTech.com"
     ;;
    (?)
        echo -e "Invalid Option"
        usage
        exit;;
  esac
done
# Checking for no attribute.
if [ -z "$1" ]
 then
  usage
  exit 1
fi
