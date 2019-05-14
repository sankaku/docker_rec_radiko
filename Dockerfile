FROM debian:stretch
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    rtmpdump \
    swftools \
    libxml2-utils \
    ffmpeg \
    libavcodec-extra \
    wget \
    && wget https://gist.githubusercontent.com/matchy2/3956266/raw/371be42108ea0c4a96c488f36a44b98deb17008f/rec_radiko.sh -O /usr/local/bin/rec_radiko.sh \
    && chmod +x /usr/local/bin/rec_radiko.sh

RUN wget https://gist.githubusercontent.com/matchy2/9515cecbea40918add594203dc61406c/raw/39bf561beb86d5fb79667e23440072afc88833db/rec_nhk.sh -O /usr/local/bin/rec_nhk.sh \
    && chmod +x /usr/local/bin/rec_nhk.sh

ENV TZ Asia/Tokyo
WORKDIR /usr/volume

