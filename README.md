# Plesk2Dropbox
####Plesk2Dropbox: Simple to use Plesk Backup Script for Dropbox
Sign up for Dropbox: https://db.tt/WrOYCd4V

Using my link will give me additional space on my Dropbox Account.
```
Usage: plesk2dropbox-backup.sh [-v : Verbose Mode] [-r : Run Backup] [-s : Dropbox Status] [-u : Update Script] [-h: Display Help]
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

**Revision history:**
- 0.1 - Initial version
- 0.2 - Changed from dash to bash and converted echo strings. Set TERM environment variable to avoid error message in Cron job. Added ability to check the status of uploading your current backup.
- 0.3.0 - Adjusted path to be compatible with CentOS.
- 0.4.0 - Changed to Plesk Backup utility fullbackup.php
- 0.4.1 - Implemented version check/update and .cfg file for custom settings.
- 0.4.2 - Fixed error creating config file. Removed unused text and spacing from script.
- 0.4.3 - Add Dropbox Command Line Script
