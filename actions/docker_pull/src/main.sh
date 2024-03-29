#!/bin/bash
set -e
# Read named command line arguments into an args variable
while getopts n:t:r:u:p:o:a: flag
do
    case "${flag}" in
        n) docker_image_name=${OPTARG};;
        t) docker_image_tag=${OPTARG};;
        r) repo_url=${OPTARG};;
        u) repo_user_name=${OPTARG};;
        p) repo_password=${OPTARG};;
        o) output_docker_image_tag=${OPTARG};;
        a) output_docker_image_name=${OPTARG};;
    esac
done

echo $docker_image_name
echo $docker_image_tag
echo $repo_url
echo $repo_user_name
echo $repo_password
echo $output_docker_image_tag
echo $output_docker_image_name
echo Logging into $repo_url 
if [ -z $repo_user_name  ]
then
    echo $repo_password | docker login $repo_url -u $ --password-stdin
else
    echo $repo_password | docker login $repo_url --username $repo_user_name --password-stdin
fi

DOCKER_IMAGE_NAME=$output_docker_image_name:$output_docker_image_tag
echo Pulling $docker_image_name:$docker_image_tag Image from $repo_url
docker pull $repo_url/$docker_image_name:$docker_image_tag
docker tag $repo_url/$docker_image_name:$docker_image_tag $output_docker_image_name:$output_docker_image_tag
DOCKER_IMAGE_DETAILS=$(docker image inspect $output_docker_image_name:$output_docker_image_tag)
echo "docker_image_details=$(echo $DOCKER_IMAGE_DETAILS)" >> $GITHUB_OUTPUT
echo "docker_image_name=$(echo $DOCKER_IMAGE_NAME)" >> $GITHUB_OUTPUT

