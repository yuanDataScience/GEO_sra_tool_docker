# GEO_sra_tool_docker
This repo shows the docker file for buiding the docker image to query GEO public RNA Seq dataset. 

## Build 
docker build -t geo .

## Usage 
### Configure

```
export AWS_ACCESS_KEY_ID="<id>"
export AWS_SECRET_ACCESS_KEY="<key>"
export AWS_DEFAULT_REGION="<region>"
```
### for downloading fastq.gz files of a specific GSE number:

docker run --name geo -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d -v $(pwd):/root/ncbi/public/sra [yourdockerimage] GSEXXXXXX s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) 

### for downloading missing fastq.gz files by designating the s3 folder and srr numbers

docker run --name geo -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d -v $(pwd):/root/ncbi/public/sra --entrypoint sra_missing_file.sh [yourdockerimage] s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) SRRXXXXXXX SRRXXXXXXX

### To obtain the mapping ifle for all the gsm -> srr numbers for the give GSE numbers (can be multiple GSE numbers)

#### a. to upload the mapping file to the designated s3 folder:

docker run --name geo -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -d -v $(pwd):/home --entrypoint sra_missing_file.sh [yourdockerimage] s3://yours3bucketfolder/(s3 bucket folder MUST ended by /) GSExxxxxxx GSExxxxxxx 
  
#### b. to obtain and save the mapping files on the current local directory:

docker run --name geo -e "MODE=local" -d -v $(pwd):/home --entrypoint gsm_map.sh [yourdockerimage] GSEXXXXXXX GSEXXXXXXX
To run the docker, users need to input the GSE nubmer and a AWS s3 bucket folder to store the fastq.gz files.
In addition, users can retrieve a mapping file that maps each GEO sample number (GSM number) to SRR number to the designated s3 folder by running srr_map.sh file.
It is inevitable that there will be some files missed during the download process. Users can run sra_missing_files.sh 

Finally, the instruction.ipynb jupyter notebook contains the aws cli and docker command to build and push the docker
to AWS ECR and run the docker image in AWS ECS

Please note that some sra and the resulting fastq.gz files will be large (> 7G). In addition, the gsm to srr mapping requires to download SRA_Accessions.tab in the docker container instance, which is > 5 G. Therefore, please make sure the cluster/EC2 instances running the docker has enough space. 
