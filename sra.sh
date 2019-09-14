#!/usr/bin/env bash


GSE=$1
s3_folder=$2  # the s3_folder should contain / at the end
DATE=`date '+%Y%m%d'`

# define the s3 folder to save the fastq.gz files 
folder_name="$s3_folder$GSE.$DATE/"

# extract srx numbers for the given GSE number
srx=$(esearch -db gds -query "$GSE[ACCN] AND GSM[ETYP]" | \
  efetch -format docsum | \
  xtract -pattern ExtRelation -element TargetObject)

# traverse the srr numbers, download, validate and convert the sra
# files to fastq files, and delelte the sra and fastq files after
# pushing the fasfq files to s3 folder
for a in ${srx[@]}; do 
       	srr=$(esearch -db sra -query "$a[ACCN]" | efetch -format docsum | \
    xtract -pattern DocumentSummary  -element Run@acc)
 
  # download, validate and convert each sra file to fastq file(s)  
  prefetch $srr && vdb-validate $srr && cd /root/ncbi/public/sra && fastq-dump --split-files -I --gzip *.sra
  
  # remove the downloaded sra file  
  rm -f *.sra
  
 # find and push all the fastq.gz files to s3 folder, and then delete the fastq.gz file from docker container 
  gz_files=$(ls *.gz)
  for f in $gz_files; do
     aws s3 cp $f $folder_name$f  --profile personal;
     echo $folder_name$f >> s3list.txt;
     rm -f $f
  done   
done

cd /root/ncbi/public/sra
s3list="s3list.txt"
aws s3 cp s3list.txt $folder_name$s3list --profile personal 
