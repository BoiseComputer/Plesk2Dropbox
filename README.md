# Plesk2Dropbox
####Plesk2Dropbox: Simple to use Plesk Backup Script for Dropbox
```
Usage: plesk2dropbox-backup.sh [-v : Verbose Mode] [-r : Run Backup] [-s : Dropbox Status] [-u : Update Plesk2Dropbox] [-h: Display Help]
  -v : Displays a detailed output of settings and verifies all folders exist.
  -r : Runs the script. If running in a cron job you will need to run this argument.
  -s : Checks the current status of any Dropbox uploads and downloads.
  -u : Check for an update to Plesk2Dropbox Github.
  -h : Displays this help page.
```
Filenames will resemble: Saturday.tar, Monday.tar, etc.

- A backup file will not be created unless you use the -r option.
- Run the -v option to verify/create the configuration file before attempting to use the -r option.
- Edit backup paths in the /etc/plesk2dropbox/plesk2dropbox.cfg file.
- You **must** have Dropbox installed and configured prior to running this script.
