#!/usr/bin/bash

source_folder=$1
dest_folder=$2

for i in $(ls $source_folder/); do
	base="$(basename -- $i)"
	iconv -f utf-8 -t utf-8 -c "$source_folder/$i" > "$dest_folder/$base"
done	
