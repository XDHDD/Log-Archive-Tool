#!/bin/bash

target_path=/var/log/ # default backup target
backup_path=/var/backup/ # default path of backup place
tar_ext=".tar.gz" # default extension
compress_type="z" # default comprassion
delimiter=""  # default delimiter
verbose="" # default no output of archive content
custom_target=0  # var if -p given

# main func
main(){

  if [[ ! -d $target_path ]]; then
    echo "No directory found for backup: $target_path"; exit 1
  fi

  if [[ "$compress_type" == "z" ]]; then
    tar_ext=".tar.gz"
    echo "Chosen type: .tar.gz"

  elif [[ "$compress_type" == "j" ]]; then
    tar_ext=".tar.bz2"
    echo "Chosen type: .tar.bz2"

  elif [[ "$compress_type" == "J" ]]; then
    tar_ext=".tar.xz"
    echo "Chosen type: .tar.xz"

  else
    echo "Wrong argument: '${compress_type}'. See log-archive --help"; exit 1
  fi

  if [[ ! -d $backup_path ]]; then
    mkdir -p $backup_path
  fi

  if [[ "$delimiter" != "" && "$delimiter" != "-" && "$delimiter" != "_" && "$delimiter" != "#" && "$delimiter" != "." ]]; then
    echo "Unsupported delimiter: $delimiter"; exit 1
  fi


  date_ymd="%Y$delimiter%m$delimiter%d" # date format like year, month, day
  date_hms="%H$delimiter%M$delimiter%S" # time format like hour, minute, second
  timestamp="$(date +"$date_ymd"_"$date_hms")" # default timestamp
  full_name="log_archive_$timestamp$tar_ext" # full name of backup file


  tar -c"$verbose""$compress_type"f "$full_name" -C "$target_path" . # creating tar archive with comprassion
  file_size=$(stat -c "%s" "$full_name" | numfmt --to=iec) # calculating backup size
  mv log_archive_"$timestamp""$tar_ext" "$backup_path" # copy to backup directory
  echo "Created backup file $full_name, $file_size" | tee logger # show output of executed script
}



# help func
help() {
  cat << EOF
log-archive is utility for making backups to /var/backup path with timestamp.

Usage: log-archive <options> <value> <target>

Options:
  -h,             Show this help
  -c,             Comprassion for tar. Available values:
                  - J value for xz;
                  - j value for bz2;
                  - z value for gzip
  -p,             Path of archived folder. Default value is /var/log/.
  -d,             Delimiter for timestamp. Default value is empty. Available values:
                  - '-'
                  - '_'
                  - '#'
                  - '.'
  -v,             Show output during running command.

Examples:

  1.Default usage: log-archive

  2.Run log-archive with target: log-archive /var/log/apt or log-archive -c j /var/log/apt or log-archive -c j -p /var/log/apt 

  3.Override comprassion type with custom delimiter: log-archive -c J -d '#'

  4.Make a backup of /var/log/messages: log-archive -c z /var/log/messages

EOF
}

# parsing keys and args

while getopts ":c:hp:d:v" opt; do
  case "$opt" in
    c) compress_type="$OPTARG"
    ;;
    h) help; exit 1
    ;;
    p) target_path="$OPTARG"
    ;;
    d) delimiter="$OPTARG"
    ;;
    v) verbose="v"
    ;;
    \?)
      echo 'No such key' 2>&1
      exit 1
      ;;
  esac
done


# Shift processed options
shift $((OPTIND - 1))

# If there is no -p key, take first positional arg
if [[ $custom_target -eq 0 && -n "$1" ]]; then
    target_path="$1"
fi
echo $1
main
