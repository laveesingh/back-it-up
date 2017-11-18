#! /bin/sh


# color codes

Black='\033[0;30m'
DarkGray='\033[1;30m'
Red='\033[0;31m'
LightRed='\033[1;31m'
Green='\033[0;32m'
LightGreen='\033[1;32m'
Orange='\033[0;33m'
Yellow='\033[1;33m'
Blue='\033[0;34m'
LightBlue='\033[1;34m'
Purple='\033[0;35m'
LightPurple='\033[1;35m'
Cyan='\033[0;36m'
LightCyan='\033[1;36m'
LightGray='\033[0;37m'
White='\033[1;37m'
NC='\033[0m'


# some standard paths


USBLINK="/dev/sdb1"
USBPATH="/media/usb_dir/"
BACKPATH="~/Desktop/backup/"


# define a function to fetch relative path
# given absolute path and current directory
get_relative_path(){
  abs_path=$1
  cur_dir=$2
  rel_path=${abs_path#$cur_dir}
  echo "$rel_path"
}


# define a function to recursively traverse 
# each file and directory inside each directory
# and so on
# given an initial path

recur(){

  # fetch the current path supplied to the function
  cur_path=$1

  echo "${LightPurple}entering into $cur_path...${NC}"

  # traverse on each file or folder in this path
  for f in $cur_path/*; do

    # check if file is a file or a folder
    if [ -f "${f}" ]; then
      # it's a file, so find its relative path and
      # copy it into appropriate directory,
      # which should have been already created
      rel_path=`get_relative_path "${f}" /media/usb_dir/`
      echo "${DarkGray}backing up ${rel_path}"
      cp "${f}" ~/Desktop/backup/"${rel_path}"

    fi
    if [ -d "$f" ]; then
      # it's a directory, so find its relative path and
      # create this directory in backup directory
      rel_path=`get_relative_path "${f}" /media/usb_dir/`
      mkdir -p ~/Desktop/backup/$rel_path

      # recursively traverse this directory
      echo "${Red}recurring for ${f}${NC}"
      recur ${f}
    fi
  done;
}

# create a directory for mounting the external drive
# and remount the drive properly

# umount the usb
sudo umount $USBLINK

# check if directory for mounting doesn't exist
if [ ! -d $USBPATH ]; then
  echo "${Blue}creating $USBPATH...${NC}"

  # create one
  mkdir $USBPATH
else 
  
  # the directory already exists
  echo "${Blue}$USBPATH exists!!!${NC}"
fi
sudo mount $USBLINK $USBPATH


# crete a directory for backup may be on desktop

# check if such directory doesn't exist already
if [ ! -d ~/Desktop/backup ]; then
  echo "${Green}creating directory for backup...${NC}"

  # create one
  mkdir ~/Desktop/backup
else
  
  # the directory already exists
  echo "${Green}directory for backup exists!!!${NC}"
fi


# move into the usb path
cd $USBPATH


# Run the traversal
recur /media/usb_dir
