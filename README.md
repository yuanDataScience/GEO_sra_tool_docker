# GEO_sra_tool_docker
This docker allows users to upload the fastq.gz files of GEO public RNA Seq dataset to s3 folder based on GSE numbers without having to install aws cli and GEO packages for downloading RNA-Seq data. 

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

### To downloading missing fastq.gz files by designating the s3 folder and SRR numbers
It is inevitable that some files will be missed when downloading by GSE number, especially when a specific GSE number contains large amount of samples. Once you figure out the list of the missed SRR numbers for a given GSE download, you can use this command to upload the missed fastq.gz files to the designated s3 folder.
 
```
docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d  --entrypoint sra_missing_file.sh huangyuan2000/geo_download_to_s3 s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) SRRXXXXXXX SRRXXXXXXX SRRXXXXX ...
```

### To obtain the mapping files for all the gsm -> srr numbers for given GSE numbers (can be multiple GSE numbers)

#### a. to upload the mapping files to the designated s3 folder:
```
docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d  --entrypoint sra_missing_file.sh huangyuan2000/geo_download_to_s3 s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) GSExxxxxxx GSExxxxxxx ...
```
  
#### b. to obtain and save the mapping files to the current local directory:
```
docker run --rm -e "MODE=local" -d -v $(pwd):/home --entrypoint gsm_map.sh huangyuan2000/geo_download_to_s3 GSEXXXXXXX GSEXXXXXXX ...
```

### Notifications:
Please note that some sra and the resulting fastq.gz files are large (> 7G). In addition, the gsm to srr mapping requires to download SRA_Accessions.tab in the docker container instance, which is > 5 G. Therefore, please make sure the local host machine or the cluster/EC2 instances running the docker has enough space. 
