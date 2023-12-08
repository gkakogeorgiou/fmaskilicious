FROM ubuntu:18.04

LABEL maintainer.name="Jonas Sølvsteen" maintainer.email="josl@dhigroup.com"

RUN adduser fmask
RUN usermod -aG root fmask

ARG UID=1000
ARG GID=1000
RUN groupmod --gid $GID fmask
RUN usermod --uid $UID fmask

RUN apt-get update && \
    apt-get -y install sudo wget unzip
RUN echo 'fmask ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir /mnt/output-dir
RUN chmod 777 /mnt/output-dir

RUN apt-get update && \
    apt-get install -y \
      'curl' \
      'unzip' \
      'libxmu6' \
      'openjdk-11-jdk' \
      'xserver-xorg'

COPY Fmask_4_5_Linux_mcr.install .
RUN chmod +x Fmask_4_5_Linux_mcr.install && \
    ./Fmask_4_5_Linux_mcr.install -mode silent -agreeToLicense yes && \
    rm Fmask_4_5_Linux_mcr.install

COPY run_fmask.sh /usr/local/bin/run_fmask.sh
RUN chmod +x /usr/local/bin/run_fmask.sh

COPY run_Fmask_4_5.sh /usr/GERS/Fmask_4_5/application/run_Fmask_4_5.sh
RUN chmod +x /usr/GERS/Fmask_4_5/application/run_Fmask_4_5.sh

VOLUME ["/mnt/input-dir"]
VOLUME ["/mnt/output-dir"]

WORKDIR /work
RUN chmod 777 /work /mnt/output-dir

ENV MCR_CACHE_ROOT="/tmp/mcr-cache"

ENTRYPOINT ["/usr/local/bin/run_fmask.sh"]
CMD ["--help"]
