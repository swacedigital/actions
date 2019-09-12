#!/bin/sh
export AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$INPUT_AWS_ACCESS_KEY_ID

echo "Logging in to docker registry"
docker login docker.pkg.github.com -u $INPUT_DEPLOY_USER_NAME -p $INPUT_DEPLOY_USER_TOKEN
echo "Building docker image"
docker build . --build-arg NPM_REGISTRY_TOKEN=$INPUT_NPM_REGISTRY_TOKEN -t $INPUT_REPOSITORY_URI:latest
echo "Pushing docker image"
docker push $INPUT_REPOSITORY_URI
echo "Deploying to ECS"
aws ecs update-service --force-new-deployment --cluster $INPUT_CLUSTER_NAME --service $INPUT_SERVICE_NAME --region $INPUT_ECS_REGION
echo "Finished deploy"
