#!/usr/bin/env bash
GSE=$1
s3_folder=$2  # the s3_folder should contain / at the end

# define the s3 folder to save the fastq.gz files 
folder_name="$s3_folder$GSE/"


srrs=()
start=$2
count=$3
i=0

while [[ $i -lt $count ]];do

srrs+=( "SRR"$(( $start+$i ))); 
let i=i+1
done;

for a in ${srrs[@]}; do
  prefetch $a && vdb-validate $a && cd /root/ncbi/public/sra && fastq-dump --split-files -I --gzip *.sra
  rm -f *.sra
  gz_files=$(ls *.gz);
  for f in $gz_files; do
    aws s3 cp $f $folder_name$f  --profile raIU;
    rm -f $f 
  done
  find . ! -name '*.txt' -type f -exec rm -f {} +
done

