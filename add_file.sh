#!/bin/sh

print_usage() {
  echo "\
usage: add_file -map [files] -char [files] -mod [files] -custom num [files]

Add files to the srb2kart server. The files must be in the './files' directory.
Files end up in numbered directories, eg: 20-maps, 40-chars and 60-mods.
Custom ordering is possible using the -custom argument and providing a number.
The order is decided by the numerical order of the folders.
To load hostmod first, run: \`add_file -custom 00 KL_HOSTMOD_V16.pk3\`

Files can be removed with \`add_files -rm [files]\`
and listed with \`add_files -ls\`
"
  exit 0
}

remove_files() {
  # TODO remove more than one file at a time
  echo deleting:
  while [[ -n "$1" ]]
  do
    find /addons -iname $1 -print -delete
    shift
  done
}

list_files() {
  find /addons -type l
}

directory=""

case $1 in
  -rm)
    shift 
    remove_files $@
    exit
    ;;
  -ls)
    list_files
    exit
    ;;
esac

while [[ -n "$1" ]]
do
  case $1 in
    -map)
      directory="20-maps"
      ;;
    -char)
      directory="40-chars"
      ;;
    -mod)
      directory="60-mods"
      ;;
    -custom)
      shift
      directory=$1
      ;;
    *)
      if [[ -z $directory ]] ; then print_usage ; exit ; fi
      mkdir -p /addons/$directory
      ln -s /files/$(basename $1) /addons/$directory/
      ;;
  esac
  shift
done

exit
