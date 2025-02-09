# Log-Archive-Tool
[roadmap.sh](https://roadmap.sh/projects/log-archive-tool) project

## Overview
log-archive is utility for making backups to /var/backup directory with timestamp providing a few keys for custom behavior. See `log-archive -h` to see more.

## Instalation and usage
1. Clone the project

 - ssh way: `git clone git@github.com:XDHDD/Log-Archive-Tool.git`

 - https way: `git clone https://github.com/XDHDD/Log-Archive-Tool.git`

2. Run install.sh script

- `sudo chmod +x install.sh; sudo ./install.sh`

3. Check your PATH and /usr/bin

4. Use

- Run: `log-archive.sh` or `log-archive.sh /var/log`
- Output: 
```
Chosen type: tar.gz
Created backup file log_archive_20250209_090810.tar.gz, 181K to /var/backup/
```