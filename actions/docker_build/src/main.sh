#!/bin/bash
set -e
# Read named command line arguments into an args variable
while getopts p:n:t:a: flag
do
    case "${flag}" in
        p) dockerfile_path=${OPTARG};;
        n) docker_image_name=${OPTARG};;
        t) docker_image_tag=${OPTARG};;
        a) docker_build_args=${OPTARG};;
    esac
done
echo Building Image $docker_image_name:$docker_image_tag 
DOCKER_IMAGE_NAME=$(echo "$docker_image_name" | tr '[:upper:]' '[:lower:]')
DOCKER_IMAGE_TAG=$(echo "$docker_image_tag" | tr '[:upper:]' '[:lower:]')
if [ "${docker_build_args}" = "none" ]; then
    echo "No Build Args Found, Building without arguments"
    docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG --no-cache $dockerfile_path
else
    echo "Build Args Found, Building with arguments"
    docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG --no-cache $docker_build_args $dockerfile_path
fi
echo Finished Building Image $docker_image_name:$docker_image_tag 
DOCKER_IMAGE_DETAILS=$(docker image inspect $docker_image_name:$docker_image_tag)
docker image ls
echo "docker_image_details=$(echo $DOCKER_IMAGE_DETAILS)" >> $GITHUB_OUTPUT
echo "docker_image_name=$(echo $DOCKER_IMAGE_NAME)" >> $GITHUB_OUTPUT
echo "docker_image_tag=$(echo $DOCKER_IMAGE_TAG)" >> $GITHUB_OUTPUT
