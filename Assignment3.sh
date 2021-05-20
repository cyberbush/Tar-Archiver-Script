#!/bin/bash
# to run 
# chmod +x Assignment3.sh
# bash Assigment3.sh
#
# The script is working for each case of the assignment but the file already exists case works only if you hit enter after each file you enter,
# the compiler will give a warning instead if you try to enter all on one line. Also the script has to be ended by using ctr+d 
i=0
echo Enter files to tar:
while read file ; do
	echo This is the file: $file
    ((i+=1))
	copy=1
    # first file
    if (($i==1)); then
        # make directory with first file name
        save=$file
        dir=$(echo $save | cut -f 1 -d '.')
	     tname=$dir
	     # check if theres a duplicate file and rename if true
	     if test -f $dir; then
	 	      mv $dir dupfile.tmp
		      dupf=$dir
	     fi 
	     # check if theres a duplicate directory and rename if true
	     if test -d $(pwd)/$dir; then
	 	      mv $dir dupdir
		      dupd=$dir
	     fi
		  dir+=.tmp
        mkdir $dir
    fi
	# check if the same file is already in the temp directory and let user decide what to do
	cd $dir
	if test -f $file ; then
		echo $file already exists.
		echo To overwrite file enter OW
		echo To not copy new file enter NO 
		echo To rename new file enter RN
		read answer
		case $answer in 
			"OW") cd .. ; cp $file $dir ;;
			"NO") cd .. ;;
			"RN") cd .. ; echo What is the new file name: ; read new ; mv $file $new ; cp $new $dir ;;
			*) echo Error selecting input. ;;  
		esac
		copy=0
	fi
	if ((copy==1)) ; then
	    # copy file to directory
		cd ..
		 if ! cp $file $dir; then
	    	 echo Error copying file: $file, doesn\'t have permission.
	 	 fi
	fi

done

# tar files in temp directory
tname+=.tar
tar -cvf $tname $dir 

# change renamed duplicate file back
if test -f dupfile.tmp; then
mv dupfile.tmp $dupf
fi

# change renamed duplicate directory back
if test -d $(pwd)/dupdir; then
mv dupdir $dupd
fi

# remove temp files and directory
rm -rf $dir
