
# Docker Image Repository Creation and Push

This shell script performs the following tasks:

-   Reads named command line arguments for `docker_image_name`, `docker_image_tag`, and `repo_url`
-   Describes the existence of the repository with the name of `docker_image_name`
-   If the repository does not exist, it creates a new repository with the name of `docker_image_name`
-   Inspects the `docker_image_name:docker_image_tag` image
-   Tags the `docker_image_name:docker_image_tag` image as `repo_url/docker_image_name:docker_image_tag`
-   Inspects the newly tagged image
-   Pushes the newly tagged image to the specified repository url

## Prerequisites

-   [AWS CLI](https://aws.amazon.com/cli/)
-   [Docker](https://www.docker.com/get-started)

## Usage

bashCopy code

`./docker_repo_push.sh -n [docker_image_name] -t [docker_image_tag] -r [repo_url]` 

## Example

bashCopy code

`./docker_repo_push.sh -n my_image -t latest -r 123456789012.dkr.ecr.us-east-1.amazonaws.com` 

## Options

-   `-n`: Specifies the name of the Docker image
-   `-t`: Specifies the tag of the Docker image
-   `-r`: Specifies the repository URL to push the image to

## Note

The script assumes that you have the necessary AWS CLI credentials configured to access your Amazon ECR registry in the `us-east-1` region.