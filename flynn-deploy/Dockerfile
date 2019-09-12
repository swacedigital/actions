FROM docker:stable

LABEL "name"="Flynn deploy action"
LABEL "maintainer"="Swace Digital <developer@swace.se>"
LABEL "version"="0.0.1"

LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"
LABEL "com.github.actions.name"="Flynn deploy"
LABEL "com.github.actions.description"="This is an Action to deploy automatically to a Flynn cluster."

RUN apk add --no-cache ca-certificates bash git curl \
    && rm -rf /var/cache/apk/*
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]