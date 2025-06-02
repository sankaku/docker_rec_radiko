FROM python:3.13.2-slim-bookworm

# locales-all is to avoid perl warnings
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    jq \
    rtmpdump \
    libxml2-utils \
    ffmpeg \
    libavcodec-extra \
    wget \
    curl \
    locales-all \
    zip

# Download scripts. Though these files will be overwritten in run.sh, keep here in case they can't be downloaded at runtime.
RUN curl https://raw.githubusercontent.com/uru2/radish/refs/heads/master/radi.sh -o /usr/local/bin/rec_radiko.sh
RUN chmod +x /usr/local/bin/rec_radiko.sh

COPY ./run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh

# You can remove the lines below if you don't use Fargate
## BEGIN
ADD ./run_fargate.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_fargate.sh

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install
## END

ENV TZ Asia/Tokyo
ENV WORKING_DIR /recorded
WORKDIR /recorded

