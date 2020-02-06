FROM python:3-stretch

LABEL "name"="Sentry release tagging action"
LABEL "maintainer"="Swace Digital <developer@swace.se>"
LABEL "version"="0.0.1"

LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"
LABEL "com.github.actions.name"="Sentry Release"
LABEL "com.github.actions.description"="This is an Action to run tag Sentry releases."

ENV JQ_VERSION='1.5'
ENV DOCKERVERSION=18.06.1-ce
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl groff jq && \
    apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove && \
    curl -fsSLO https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64 && \
    mv heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/aws-iam-authenticator && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz && \
    tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
    -C /usr/local/bin docker/docker && \
    rm docker-${DOCKERVERSION}.tgz && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip && \
    pip install setuptools awscli

RUN wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key -O /tmp/jq-release.key && \
    wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc -O /tmp/jq-linux64.asc && \
    wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 && \
    gpg --import /tmp/jq-release.key && \
    gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 && \
    cp /tmp/jq-linux64 /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    rm -f /tmp/jq-release.key && \
    rm -f /tmp/jq-linux64.asc && \
    rm -f /tmp/jq-linux64

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]