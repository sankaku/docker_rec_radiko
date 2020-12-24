FROM python:3.7.4-slim-stretch

# locales-all is to avoid perl warnings
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    rtmpdump \
    swftools \
    libxml2-utils \
    ffmpeg \
    libavcodec-extra \
    wget \
    curl \
    locales-all

# Download scripts. Though these files will be overwritten in run.sh, keep here in case they can't be downloaded at runtime.
ADD https://gist.githubusercontent.com/matchy2/3956266/raw/rec_radiko.sh /usr/local/bin/
ADD https://gist.githubusercontent.com/matchy2/9515cecbea40918add594203dc61406c/raw/rec_nhk.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/rec_radiko.sh /usr/local/bin/rec_nhk.sh

ADD ./run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh

# You can remove the lines below if you don't use Fargate
## BEGIN
ADD ./run_fargate.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_fargate.sh

# AWS CLI
RUN pip3 install awscli --upgrade
ENV PATH $PATH:/usr/local/lib/python3.7/site-packages/awscli
## END

ENV TZ Asia/Tokyo
ENV WORKING_DIR /recorded
WORKDIR /recorded

