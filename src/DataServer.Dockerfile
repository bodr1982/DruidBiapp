FROM alpine:3.7

RUN apk add --no-cache bash

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u111
ENV JAVA_ALPINE_VERSION 8.111.14-r0

RUN set -x && apk add --no-cache openjdk8 && [ "$JAVA_HOME" = "$(docker-java-home)" ]

COPY ./file/druid.tar.gz /druid.tar.gz
RUN tar -xzf /druid.tar.gz

COPY ./conf/druid/data&query/_common/common.runtime.properties /druid/conf/druid/_common/common.runtime.properties
COPY ./conf/druid/single/jvm.config /druid/conf/druid/single/jvm.config

RUN rm -rf *.tar.gz

COPY ./script/dataserver/start-single.sh /druid/start-single.sh

EXPOSE 8083
EXPOSE 8091

RUN chmod +x /druid/start-single.sh

CMD ["/druid/start-single.sh"]
