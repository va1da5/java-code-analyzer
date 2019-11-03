FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y wget openjdk-11-jdk unzip rpm2cpio cpio p7zip-full libperlio-gzip-perl bzip2 unrar-free xz-utils

WORKDIR /opt

RUN wget https://github.com/kwart/jd-cmd/releases/download/jd-cmd-1.0.0.Final/jd-cli-1.0.0.Final-dist.zip \
    && unzip jd-cli-1.0.0.Final-dist.zip -d jd-cli \
    && bash -c "echo \"java -jar $PWD/jd-cli/jd-cli.jar \\\$@\" > $PWD/jd-cli/jd-cli" \
    && chmod +x $PWD/jd-cli/jd-cli \
    && ln -s $PWD/jd-cli/jd-cli /usr/local/bin/jd-cli \
    && rm -rf jd-cli-1.0.0.Final-dist.zip

RUN wget https://github.com/find-sec-bugs/find-sec-bugs/releases/download/version-1.10.1/findsecbugs-cli-1.10.1.zip \
    && unzip findsecbugs-cli-1.10.1.zip -d findsecbugs \
    && ln -s $PWD/findsecbugs/findsecbugs.sh /usr/local/bin/findsecbugs.sh \
    && chmod +x $PWD/findsecbugs/findsecbugs.sh \
    && rm -rf findsecbugs-cli-1.10.1.zip

RUN mkdir -p /project/src \
    && mkdir -p /project/reports \
    && mkdir -p /project/decompiled \
    && mkdir -p /project/tmp

WORKDIR /project

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
