#! /bin/sh

USBLINK="/dev/sdb1"
USBPATH="/media/usb_dir/"
BACKPATH="~/Desktop/backup/"

# properly remount the external drive
sudo umount $USBLINK
if [ ! -d $USBPATH ]; then
  echo "creating $USBPATH"
  mkdir $USBPATH
fi
sudo mount $USBLINK $USBPATH

# create backup directory and move into the usb location 

if [ ! -d ~/Desktop/backup ]; then
  mkdir ~/Desktop/backup
fi
cd $USBPATH

get_relative_path(){
  abs_path=$1
  cur_dir=$2
  rel_path=${abs_path#$cur_dir}
  echo "$rel_path"
}


recur(){
  cur_path=$1
  echo "curpath: $cur_path"
  for f in $cur_path/*; do
    if [ -f "$f" ]; then

      # it's a file, so find its relative path and
      # copy it into appropriate directory,
      # which should have been already created
      rel_path=`get_relative_path $f /media/usb_dir/`
      echo copying : $rel_path
      cp $f ~/Desktop/backup/$rel_path
    fi
    if [ -d "$f" ]; then

      # make this directory in backup
      rel_path=`get_relative_path $f /media/usb_dir/`
      mkdir -p ~/Desktop/backup/$rel_path

      # recursively go through this directory
      recur $f
    fi
  done;
}
recur /media/usb_dir
