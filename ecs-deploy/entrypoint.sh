#!/bin/sh
export AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$INPUT_AWS_SECRET_ACCESS_KEY

REVISION_TAG="$(git rev-parse HEAD -c7)"
echo "Logging in to docker registry"
docker login docker.pkg.github.com -u $INPUT_DEPLOY_USER_NAME -p $INPUT_DEPLOY_USER_TOKEN
echo "Building docker image"
docker build . --build-arg NPM_REGISTRY_TOKEN=$INPUT_NPM_REGISTRY_TOKEN -t $INPUT_REPOSITORY_URI -t $INPUT_REPOSITORY_URI:$REVISION_TAG
echo "Pushing docker image"
docker push $INPUT_REPOSITORY_URI

echo "Get ECS task definition"
jq --version && \
aws ecs describe-task-definition --task-definition $INPUT_SERVICE_NAME --region $INPUT_ECS_REGION | \
jq '.taskDefinition' | jq '{networkMode,family,cpu,executionRoleArn,memory,requiresCompatibilities,containerDefinitions}' | \
jq --arg TAG "${INPUT_REPOSITORY_URI}:${REVISION_TAG}" '.containerDefinitions[].image = $TAG' > $GITHUB_WORKSPACE/deployment-backend.yml | \
jq '.containerDefinitions[].environment += [{ "name": "ECS_IMAGE_PULL_BEHAVIOR", "value": "once" }]' > $GITHUB_WORKSPACE/deployment-backend.yml
echo "Parsed old task definition"

echo "Deregistering outdated task definition"
jq --version && aws ecs describe-task-definition --task-definition $INPUT_SERVICE_NAME --region $INPUT_ECS_REGION | \
jq '.taskDefinition.revision' > $GITHUB_WORKSPACE/old-revision && aws ecs deregister-task-definition --region $ECS_REGION --task-definition $INPUT_SERVICE_NAME:$(cat $GITHUB_WORKSPACE/old-revision)
echo "Old task definition deregistered"

echo "Register new task definition"
aws ecs register-task-definition --cli-input-json file://deployment-backend.yml --region $INPUT_ECS_REGION
echo "New task definition registered"

echo "Deploying to ECS"
aws ecs update-service --force-new-deployment --cluster $INPUT_CLUSTER_NAME --service $INPUT_SERVICE_NAME --region $INPUT_ECS_REGION --task-definition $INPUT_SERVICE_NAME:$(($(cat $GITHUB_WORKSPACE/old-revision) + 1))
echo "Service deployed"