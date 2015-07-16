FROM debian:jessie
MAINTAINER Christophe Burki, christophe.burki@gmail.com

RUN apt-get update && apt-get install -y \
    gcc \
    make \
    autoconf \
    automake \
    curl

RUN mkdir -p /data
VOLUME ["/data"]

COPY scripts/build.sh /opt/build.sh
RUN chmod a+x /opt/build.sh

CMD ["/opt/build.sh"]
