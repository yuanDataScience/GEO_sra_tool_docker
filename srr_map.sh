


gsms=()
gsm=$(esearch -db gds -query "$GSE[ACCN] AND GSM[ETYP]" | efetch -format docsum | xtract -pattern DocumentSummary -element Accession);

echo $pwd

cd /root
lftp -c "open ftp.ncbi.nlm.nih.gov/sra/reports/Metadata && get SRA_Accessions.tab"

cd /root/ncbi/public/sra
fastq-dump --split-files -I --gzip *.sra

grep ^SRR /root/SRA_Accessions.tab | grep GSM >srr_gsm.txt
rm -f /root/SRA_Accessions.tab

for a in ${gsm[@]}; do
    grep $a srr_gsm.txt | sed 's/_r[0-9]*//' | cut -d $'\t' -f 10,11,1 >> map_batch.out;
done

srr_gsm_map="map_batch.out"
DATE=`date '+%Y%m%d'`
gz_files=$(ls *.gz);
folder_name="$s3_header$GSE.$DATE/"
s3list="s3list.txt"

for f in $gz_files; do
   aws s3 cp $f $folder_name$f  --profile personal;
   echo $folder_name$f >> s3list.txt;
done

aws s3 cp s3list.txt $folder_name$s3list --profile personal
aws s3 cp map_batch.out $folder_name$srr_gsm_map --profile personal

