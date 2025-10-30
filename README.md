# Create ext4 persistent.dat

This is a windows verssion of the ventoy bash script to create the persistent.dat image for the persistent data plugin, it supports the ext2, ext3 and ext4 filesystems and you can customize size of the image and the label of the filesystem like in the original bash script. It's fast and reliable.

## How to use it

you can use easily by just cloning the repo and calling the create.bat file. If you don't pass any argumments, you'll get a file with the default parametters, but if you want to customize the data image, you can do it with the following options.
* -s --size, the size is specified in MB and the default value is 1000 (note that I don't use MiB, I use MB).
* -t --fstype, filesystem type, the options are ext2, ext3 and ext4 and the default is ext4.
* -l --label, filesystem label, you can write whatever you want in quotes, the default label is "casper-rw".
* -o --output, name of the output file, you can specify whatever you want in quotes, the default name is "persistent.dat".