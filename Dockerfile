FROM python:3

LABEL maintainer="Yuan Huang <yuahuang@celgene.com>" \
      version="1.0"

RUN apt-get update -y && apt-get install -y wget && \
    apt-get install -y lftp && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    wget -P /usr/bin "https://raw.githubusercontent.com/inutano/pfastq-dump/master/bin/pfastq-dump" && \
    chmod +x /usr/bin/pfastq-dump && \
    wget -P / "http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.2/sratoolkit.2.9.2-ubuntu64.tar.gz" && \
    tar zxf /sratoolkit.2.9.2-ubuntu64.tar.gz && \
    cp -r /sratoolkit.2.9.2-ubuntu64/bin/* /usr/bin && \
    rm -fr /sratoolkit.2.9.2-ubuntu64*  

RUN pip install awscli && mkdir /root/.aws  
COPY ./.aws /root/.aws

USER root
WORKDIR /usr/local/ncbi

RUN apt-get update -y && apt-get install -y curl cpanminus libxml-simple-perl libwww-perl libnet-perl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz | \
    tar xzf - && \
    cpanm HTML::Entities && \
    edirect/setup.sh

COPY installconfirm /usr/local/ncbi/edirect/
COPY sra.sh /usr/local/ncbi/edirect/

WORKDIR /
COPY sra.sh /

ENV PATH="/usr/bin:/usr/local/ncbi/edirect:${PATH}"
ENTRYPOINT ["sra.sh"]
CMD []

