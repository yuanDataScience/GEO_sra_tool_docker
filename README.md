# GEO_sra_tool_docker
This repo shows the docker file for buiding the docker image to query GEO public RNA Seq dataset. 
To run the docker, users need to input the GSE nubmer and a AWS s3 bucket folder to store the fastq.gz files.
In addition, users can retrieve a mapping file that maps each GEO sample number (GSM number) to SRR number to the designated s3 folder by running srr_map.sh file.
It is inevitable that there will be some files missed during the download process. Users can run sra_missing_files.sh 

Finally, the instruction.ipynb jupyter notebook contains all the aws cli and docker command to build and push the docker
to AWS ECR and run the docker image in AWS ECS

Please note that some sra and the resulting fastq.gz files will be large (> 7G). In addition, the gsm to srr mapping requires to download SRA_Accessions.tab in the docker container instance, which is > 5 G. Therefore, please make sure the cluster/EC2 instances running the docker has enough space. 
