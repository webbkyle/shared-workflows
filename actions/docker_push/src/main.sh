#!/bin/bash
set -e
# Read named command line arguments into an args variable
while getopts n:t:r:u:p:o: flag
do
    case "${flag}" in
        n) docker_image_name=${OPTARG};;
        t) docker_image_tag=${OPTARG};;
        r) repo_url=${OPTARG};;
        u) repo_user_name=${OPTARG};;
        p) repo_password=${OPTARG};;
        o) docker_image_output_tag=${OPTARG};;
    esac
done

echo $docker_image_name
echo $docker_image_tag
echo $docker_image_output_tag
echo $repo_url
echo $repo_user_name
echo $repo_password

docker image inspect $docker_image_name:$docker_image_tag
echo Logging into $repo_url 
if [ -z $repo_user_name  ]
then
    echo $repo_password | docker login $repo_url -u $ --password-stdin
else
    echo $repo_password | docker login $repo_url --username $repo_user_name --password-stdin
fi

docker tag $docker_image_name:$docker_image_tag $repo_url/$docker_image_name:$docker_image_output_tag
echo Pushing Image to $repo_url
docker push $repo_url/$docker_image_name:$docker_image_output_tag
