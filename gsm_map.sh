#!usr/bin/env bash
set -e

mode="${MODE:-cloud}"

if [ $mode == "cloud" ]; then
	s3_header=$1
	GSE=${@:2}
elif [ $mode == "local" ]; then
   GSE=$@	
else
     echo "the MODE environment varialbe has invalid value"
     exit
fi

cd /root
lftp -c "open ftp.ncbi.nlm.nih.gov/sra/reports/Metadata && get SRA_Accessions.tab"

cd /home
grep ^SRR /root/SRA_Accessions.tab | grep GSM >srr_gsm.txt

for g in ${GSE[@]};do
	gsm=$(esearch -db gds -query "$g[ACCN] AND GSM[ETYP]" | efetch -format docsum | xtract -pattern DocumentSummary -element Accession);
        gse_file="map_batch$g.txt"

    for a in ${gsm[@]}; do
        grep $a srr_gsm.txt | sed 's/_r[0-9]*//' | cut -d $'\t' -f 10,11,1 >> $gse_file;
    done

    if [ $mode == "cloud" ]; then
	    aws s3 cp $gse_file $s3_header$gse_file
	    rm -f $gse_file
    fi
done

rm -f /root/SRA_Accessions.tab

