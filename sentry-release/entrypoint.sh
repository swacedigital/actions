#!/bin/sh
echo "Creating Sentry release.."
curl -sL https://sentry.io/get-cli/ | bash
VERSION=`sentry-cli releases propose-version`
export SENTRY_AUTH_TOKEN=$INPUT_SENTRY_AUTH_TOKEN
sentry-cli releases --org $INPUT_SENTRY_ORG new "$VERSION" --project $INPUT_SENTRY_PROJECT
sentry-cli releases --org $INPUT_SENTRY_ORG set-commits "$VERSION" --auto
sentry-cli releases --org $INPUT_SENTRY_ORG finalize $VERSION