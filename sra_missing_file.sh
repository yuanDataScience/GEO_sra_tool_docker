#!/usr/bin/env bash
# This bash file download the RNA-Seq files according to the 
# input SRR numbers, convert the files into fastq.gz files, 
# and upload the file to the s3 folder defined by the input
# s3_folder and GSE number.

# Usage: docker run --name sra_download -d -v $(pwd):/root/ncbi/public/sra <docker_img_name such as "sra_srr"> srr_missing_file.sh s3://your_bucket/your_folder SRRXXXXX SRRXXXXX. You can also input an array containing all SRR numbers


srrs=${@:2}
folder_name=$1

for a in ${srrs[@]}; do
  prefetch $a
done

cd /root/ncbi/public/sra
fastq-dump --split-files -I --gzip *.sra

gz_files=$(ls *.gz);
for f in $gz_files; do
  aws s3 cp $f $folder_name$f --profile personal
done    

