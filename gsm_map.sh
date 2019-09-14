#!usr/bin/env bash

GSE=$1
gsms=()

gsm=$(esearch -db gds -query "$GSE[ACCN] AND GSM[ETYP]" | efetch -format docsum | xtract -pattern DocumentSummary -element Accession);

cd /root
lftp -c "open ftp.ncbi.nlm.nih.gov/sra/reports/Metadata && get SRA_Accessions.tab"

grep ^SRR /root/SRA_Accessions.tab | grep GSM >srr_gsm.txt
rm -f /root/SRA_Accessions.tab

for a in ${gsm[@]}; do
    grep $a srr_gsm.txt | sed 's/_r[0-9]*//' | cut -d $'\t' -f 10,11,1 >> map_batch.out;
done

srr_gsm_map="map_batch.out"
DATE=`date '+%Y%m%d'`
folder_name="$s3_header$GSE.$DATE/"

aws s3 cp map_batch.out $folder_name$srr_gsm_map 

