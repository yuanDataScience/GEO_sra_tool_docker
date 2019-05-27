# GEO_sra_tool_docker
This repo shows the docker file for buiding the docker image to query GEO public RNA Seq dataset. 
To run the docker, users need to input the GSE nubmer and a AWS s3 bucket folder to store the fastq.gz files.
The fastq.gz files, a mapping file that maps 
Each GEO sample number (GSM number) to SRR number, and a s3list file that contians a list of all the fastq.gz files pushed to 
s3 bucket will be stored in the designated s3 folder.

In addition, the instruction.ipynb jupyter notebook contains all the aws cli and docker command to build and push the docker
to AWS ECR and run the docker image in AWS ECS
