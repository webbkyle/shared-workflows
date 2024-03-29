# Docker Image Builder

A shell script for building Docker images and storing the image details as outputs for GitHub Actions.

## Usage

The script takes in three named command line arguments:

-   `-p` or `--dockerfile_path`: the path to the Dockerfile for building the image
-   `-n` or `--docker_image_name`: the name of the Docker image to be built
-   `-t` or `--docker_image_tag`: the tag for the Docker image

Example:

bashCopy code

`./docker_image_builder.sh -p /path/to/Dockerfile -n my_image -t latest` 

## Outputs

The script outputs the following environment variables:

-   `docker_image_details`: the details of the built Docker image, obtained from `docker image inspect`
-   `docker_image_name`: the lowercase name of the built Docker image
-   `docker_image_tag`: the lowercase tag of the built Docker image

## Note

The script sets the `-e` option, which causes the script to exit immediately if any command returns a non-zero exit code.