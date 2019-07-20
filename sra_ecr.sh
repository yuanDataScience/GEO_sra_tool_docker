#!/usr/bin/env bash


GSE=$1
s3_header=$2
DATE=`date '+%Y%m%d'`
folder_name="$s3_header$GSE.$DATE/"

rs=()
srx=$(esearch -db gds -query "$GSE[ACCN] AND GSM[ETYP]" | \
  efetch -format docsum | \
  xtract -pattern ExtRelation -element TargetObject)

for a in ${srx[@]}; do
  srr=$(esearch -db sra -query "$a[ACCN]" | efetch -format docsum | \
    xtract -pattern DocumentSummary  -element Run@acc)
  
  prefetch $srr
  cd /root/ncbi/public/sra
  fastq-dump --split-files -I --gzip *.sra
  rm -f *.sra
  gz_file=$(ls *.gz);
  for f in $gz_files; do
	  aws s3 cp $f $folder_name$f --profile personal 
	  rm -f $f
  done	  
done

