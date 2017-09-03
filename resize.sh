#!/bin/bash

#sourceDir="TestData"
#destDir="Converted"

sourceDir="$1"
destDir="$2"
minSize="$3"
# Optional paramater. Store filenames of resized files in given log file
logFile="$4"

# Check if parameters are empty or not set
if [[ -z "$sourceDir" || -z "$destDir" || -z "$minSize" ]]; then
	echo "Not enough parameters"
	exit 0
fi

# Create empty log file or clear log file if it exists when log file was specified
if [[ -n "$logFile" ]]; then
	> $logFile
fi

# Count of all files in source dir
fileCnt="$(find $sourceDir -type f | wc -l)"
# Count how many files was checked
cnt=1
# Loop over files in source dir
for filename in "$sourceDir"/*
do
	# Name without dir
	basename="$(basename $filename)"
	# Only convert files
	if [ -f "$filename" ]; then
		echo "($cnt/$fileCnt) $filename"
		(( cnt++ ))
		width="$(identify -format '%w' $filename)"
		height="$(identify -format '%h' $filename)"
		if (($width < $minSize || $height < $minSize)); then
			# Resize image (with ImageMagick) to a min length of the given min size of 
			# the smalles site and keep aspect ratio
			convert $filename -resize "$minSize"x"$minSize"^ $destDir/$basename
			printf "\t \033[0;32mConverted\033[0m\n"
			# Store name of converted file in log file if a log file was specified
			if [[ -n "$logFile" ]]; then
				echo "$basename" >> "$logFile"
			fi
		fi
	fi
done