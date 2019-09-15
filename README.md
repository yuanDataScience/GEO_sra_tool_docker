# GEO_sra_tool_docker
This docker allows users to query GEO public RNA Seq dataset and upload the converted fastq.gz files to s3 folder. 

## Build 
docker build -t huangyuan2000/geo_download_to_s3 .

## Usage 
### Configure

```
export AWS_ACCESS_KEY_ID="<id>"
export AWS_SECRET_ACCESS_KEY="<key>"
export AWS_DEFAULT_REGION="<region>"
```
### To download fastq.gz files of a specific GSE number:
```
docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d huangyuan2000/geo_download_to_s3 GSEXXXXXX s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) 
```

### To downloading missing fastq.gz files by designating the s3 folder and srr numbers
```
docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d  --entrypoint sra_missing_file.sh huangyuan2000/geo_download_to_s3 s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) SRRXXXXXXX SRRXXXXXXX SRRXXXXX ...
```

### To obtain the mapping ifle for all the gsm -> srr numbers for the give GSE numbers (can be multiple GSE numbers)

#### a. to upload the mapping file to the designated s3 folder:
```
docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d  --entrypoint sra_missing_file.sh huangyuan2000/geo_download_to_s3 s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) GSExxxxxxx GSExxxxxxx ...
```
  
#### b. to obtain and save the mapping files to the current local directory:
```
docker run --rm -e "MODE=local" -d -v $(pwd):/home --entrypoint gsm_map.sh huangyuan2000/geo_download_to_s3 GSEXXXXXXX GSEXXXXXXX ...
```

### Notifications:
Please note that some sra and the resulting fastq.gz files will be large (> 7G). In addition, the gsm to srr mapping requires to download SRA_Accessions.tab in the docker container instance, which is > 5 G. Therefore, please make sure the cluster/EC2 instances running the docker has enough space. 
