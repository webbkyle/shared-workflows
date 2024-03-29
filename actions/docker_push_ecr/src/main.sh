#!/bin/sh
set -e

# Read named command line arguments into an args variable
while getopts n:t:r: flag; do
    case "${flag}" in
        n) docker_image_name=${OPTARG} ;;
        t) docker_image_tag=${OPTARG} ;;
        r) repo_url=${OPTARG} ;;
    esac
done

result_code=$(aws ecr describe-repositories --region us-east-1 --repository-names "$docker_image_name")
result_code=$?
echo "Result code is $result_code"
if [ "$result_code" -eq 255 ] || [ "$result_code" -eq 254 ]; then
        echo "Repository does not exist, creating $docker_image_name repo"
        aws ecr create-repository --repository-name "$docker_image_name" --image-scanning-configuration scanOnPush=false --image-tag-mutability MUTABLE --encryption-configuration encryptionType=AES256
fi        

if [ "$result_code" -eq 0 ]; then
    docker image inspect "$docker_image_name:$docker_image_tag"
    docker tag "$docker_image_name:$docker_image_tag" "$repo_url/$docker_image_name:$docker_image_tag"
    docker tag "$docker_image_name:$docker_image_tag" "$repo_url/$docker_image_name:latest"
    docker image inspect "$repo_url/$docker_image_name:$docker_image_tag"
    
    if docker manifest inspect "$repo_url/$docker_image_name:$docker_image_tag" > /dev/null 2>&1; then
        echo "The Docker image $docker_image_name:$docker_image_tag exists in ECR."
    else
        echo "Pushing $repo_url/$docker_image_name:$docker_image_tag Image to $repo_url"
        docker push "$repo_url/$docker_image_name:$docker_image_tag"
        echo "Pushed Image to $repo_url successfully!"
    fi
fi

# Check if the ECR repository is mutable
# Capture the tag immutability status
tag_immutability=$(aws ecr describe-repositories --repository-names "$docker_image_name" --query "repositories[].imageTagMutability" --output text)

# Check if tag immutability is "MUTABLE"
if [ "$tag_immutability" = "MUTABLE" ]; then
    # Perform actions when tag immutability is "MUTABLE"
    docker push "$repo_url/$docker_image_name:latest"
else
    # Perform actions when tag immutability is not "MUTABLE"
    echo "ECR repository is not mutable. Skipping docker push on tag 'latest'."
fi

