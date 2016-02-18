# Plesk2Dropbox
####Plesk2Dropbox: Simple to use Plesk Backup Script for Dropbox
```
Usage: plesk2dropbox-backup.sh [-v : Verbose Mode] [-r : Run Backup] [-s : Dropbox Status] [-h: Display Help]
  -v : Displays a detailed output of settings and verifies all folders exist.
  -r : Runs the script. If running in a cron job you will need to run this argument.
  -s : Checks the current status of any Dropbox uploads and downloads.
  -h : Displays this help page.
```
Filenames will resemble: Saturday.tar, Monday.tar, etc.

- A backup file will not be created unless you use the -r option.
- Run the -v option to verify your configuration is correct before attempting to use the -r option.
- Make sure you verify lines **#35** and **#38** to ensure they are compatible with your system configuration.
- You **must** have Dropbox installed and configured prior to running this script.
