#!/bin/sh
chown -R $(whoami) /usr/local/bin
L=/usr/local/bin/flynn && curl -sSL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L
echo $INPUT_FLYNN_CA_CERT | tee -a /usr/local/share/ca-certificates/flynn.crt
update-ca-certificates || true
flynn cluster add -p $INPUT_FLYNN_TLS_PIN default https://controller.$INPUT_FLYNN_DOMAIN $INPUT_FLYNN_CONTROLLER_KEY
git remote add flynn https://git.$INPUT_FLYNN_DOMAIN/$INPUT_FLYNN_APP_NAME.git
git push -f flynn HEAD:master