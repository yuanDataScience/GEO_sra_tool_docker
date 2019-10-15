#!/usr/bin/env bash
folder_name="$1/"


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

